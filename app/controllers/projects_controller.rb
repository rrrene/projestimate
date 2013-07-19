#encoding: utf-8
#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012-2013 Spirula (http://www.spirula.fr)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
########################################################################
class ProjectsController < ApplicationController
  include WbsActivityElementsHelper
  include ModuleProjectsHelper
  include PemoduleEstimationMethods

  helper_method :sort_column
  helper_method :sort_direction

  before_filter :load_data, :only => [:update, :edit, :new, :create]
  before_filter :get_record_statuses

  def load_data
    if params[:id]
      @project = Project.find(params[:id])
    else
      @project = Project.new :state => 'preliminary'
    end
    @user = @project.users.first
    @project_areas = ProjectArea.all
    @platform_categories = PlatformCategory.all
    @acquisition_categories = AcquisitionCategory.all
    @project_categories = ProjectCategory.all
    @pemodules ||= Pemodule.all
    @project_modules = @project.pemodules
    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
    @module_positions_x = @project.module_projects.order(:position_x).all.map(&:position_x).max
    @organizations = Organization.all
    @project_modules = @project.pemodules
    @project_security_levels = ProjectSecurityLevel.all
    @module_project = ModuleProject.find_by_project_id(@project.id)
  end

  def index
    set_page_title 'Projects'
    @projects = Project.all
  end

  def new
    authorize! :create_project_from_scratch, Project
    set_page_title 'New project'
  end

  #Create a new project
  def create
    authorize! :create_project_from_scratch, Project
    set_page_title 'Create project'
    @project = Project.new(params[:project])
    @wbs_activity_elements = []

    @project.is_locked = false
    @project.save

    if @project.start_date.nil? or @project.start_date.blank?
      @project.start_date = Time.now.to_date
      @project.save
    end

    begin
      @project.transaction do
        if @project.save
          #New default Pe-Wbs-Project
          pe_wbs_project_product = @project.pe_wbs_projects.build(:name => "#{@project.title} WBS-Product - Product Breakdown Structure", :wbs_type => 'Product')
          pe_wbs_project_activity = @project.pe_wbs_projects.build(:name => "#{@project.title} WBS-Activity - Activity breakdown Structure", :wbs_type => 'Activity')

          if pe_wbs_project_product.save
            ##New root Pbs-Project-Element
            pbs_project_element = pe_wbs_project_product.pbs_project_elements.build(:name => "Root Element - #{@project.title} WBS-Product", :is_root => true, :work_element_type_id => default_work_element_type.id, :position => 0)
            pbs_project_element.save
            pe_wbs_project_product.save
          else
            redirect_to redirect(edit_project_path(@project)), notice: "#{pe_wbs_project_product.errors.full_messages.to_sentence}."
          end

          if pe_wbs_project_activity.save
            ##New Root Wbs-Project-Element
            wbs_project_element = pe_wbs_project_activity.wbs_project_elements.build(:name => "Root Element - #{@project.title} WBS-Activity", :is_root => true, :description => 'WBS-Activity Root Element', :author_id => current_user.id)
            wbs_project_element.save
          else
            redirect_to redirect(edit_project_path(@project)), notice: "#{pe_wbs_project_activity.errors.full_messages.to_sentence}."
          end

          #Get the capitalization module from ApplicationController
          #When creating project, we need to create module_projects for created capitalization
          unless @capitalization_module.nil?
            cap_module_project = @project.module_projects.build(:pemodule_id => @capitalization_module.id, :position_x => 0, :position_y => 0)
            if cap_module_project.save
              #Create the corresponding EstimationValues
              unless @project.organization.nil? || @project.organization.attribute_organizations.nil?
                @project.organization.attribute_organizations.each do |am|
                  ['input', 'output'].each do |in_out|
                    mpa = EstimationValue.create(:pe_attribute_id => am.pe_attribute.id,
                           :module_project_id => cap_module_project.id,
                           :in_out => in_out,
                           :is_mandatory => am.is_mandatory,
                           :description => am.pe_attribute.description,
                           :display_order => nil,
                           :string_data_low => {:pe_attribute_name => am.pe_attribute.name, :default_low => ''},
                           :string_data_most_likely => {:pe_attribute_name => am.pe_attribute.name, :default_most_likely => ''},
                           :string_data_high => {:pe_attribute_name => am.pe_attribute.name, :default_high => ''})
                           #:custom_attribute => am.custom_attribute,
                           #:project_value => am.project_value)
                  end
                end
              end
            end
          end

          if current_user.groups.map(&:code_group).include? ('super_admin')
            current_user.project_ids = current_user.project_ids.push(@project.id)
            current_user.save
          end

          redirect_to redirect_apply(edit_project_path(@project)), notice: "#{I18n.t(:notice_project_successful_created)}"
        else
          flash[:error] = "#{I18n.t(:error_project_creation_failed)} #{@project.errors.full_messages.to_sentence}"
          render :new
        end
      end

    rescue ActiveRecord::UnknownAttributeError, ActiveRecord::StatementInvalid, ActiveRecord::RecordInvalid => error
      flash[:error] = "#{I18n.t (:error_project_creation_failed)} #{@project.errors.full_messages.to_sentence}"
      redirect_to :back
    end

  end

  #Edit a selected project
  def edit
    set_page_title 'Edit project'

    @project = Project.find(params[:id])
    @capitalization_module_project = @capitalization_module.nil? ? nil : @project.module_projects.find_by_pemodule_id(@capitalization_module.id)

    @pe_wbs_project_product = @project.pe_wbs_projects.products_wbs.first
    @pe_wbs_project_activity = @project.pe_wbs_projects.activities_wbs.first
    @wbs_activity_ratios = []

    # Get the max X and Y positions of modules
    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
    @module_positions_x = @project.module_projects.order(:position_x).all.map(&:position_x).max

    defined_wbs_activities = WbsActivity.where('record_status_id = ?', @defined_status.id).all
    @wbs_activities = defined_wbs_activities.reject { |i| @project.included_wbs_activities.include?(i.id) }
    @wbs_activity_elements = []
    @wbs_activities.each do |wbs_activity|
      elements_root = wbs_activity.wbs_activity_elements.elements_root.first
      unless elements_root.nil?
        @wbs_activity_elements << elements_root #wbs_activity.wbs_activity_elements.last.root
      end
    end
  end


  def update
    set_page_title 'Edit project'

    @pe_wbs_project_product = @project.pe_wbs_projects.products_wbs.first
    @pe_wbs_project_activity = @project.pe_wbs_projects.activities_wbs.first
    @wbs_activity_elements = []
    @capitalization_module_project = @capitalization_module.nil? ? nil : @project.module_projects.find_by_pemodule_id(@capitalization_module.id)

    @project.users.each do |u|
      ps = ProjectSecurity.find_by_user_id_and_project_id(u.id, @project.id)
      if ps
        ps.project_security_level_id = params["user_securities_#{u.id}"]
        ps.save
      else
        ProjectSecurity.create(:user_id => u.id,
                               :project_id => @project.id,
                               :project_security_level_id => params["user_securities_#{u.id}"])
      end
    end

    @project.groups.each do |gpe|
      ps = ProjectSecurity.find_by_group_id_and_project_id(gpe.id, @project.id)
      if ps
        ps.project_security_level_id = params["group_securities_#{gpe.id}"]
        ps.save
      else
        ProjectSecurity.create(:group_id => gpe.id,
                               :project_id => @project.id,
                               :project_security_level_id => params["group_securities_#{gpe.id}"])
      end
    end

    # Get the max X and Y positions of modules
    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
    @module_positions_x = @project.module_projects.order(:position_x).all.map(&:position_x).max

    #Get the project Organization before update
    project_organization = @project.organization

    if @project.update_attributes(params[:project])

      begin
        date = Date.strptime(params[:project][:start_date], I18n.t('date.formats.default'))
        @project.start_date = date
      rescue
        @project.start_date = Time.now.to_date
      end

      # Capitalization Module
      unless @capitalization_module.nil?
        # Get the project capitalization module_project or create if it doesn't exist
        cap_module_project = @project.module_projects.find_by_pemodule_id(@capitalization_module.id)
        if cap_module_project.nil?
          cap_module_project = @project.module_projects.create(:pemodule_id => @capitalization_module.id, :position_x => 0, :position_y => 0)
        end

        # Create the project capitalization module estimation_values if project organization has changed and not nil
        if project_organization.nil? && !@project.organization.nil?

          #Create the corresponding EstimationValues
          unless @project.organization.attribute_organizations.nil?
            @project.organization.attribute_organizations.each do |am|
              ['input', 'output'].each do |in_out|
                mpa = EstimationValue.create(:pe_attribute_id => am.pe_attribute.id,
                         :module_project_id => cap_module_project.id,
                         :in_out => in_out,
                         :is_mandatory => am.is_mandatory,
                         :description => am.pe_attribute.description,
                         :display_order => nil,
                         :string_data_low => {:pe_attribute_name => am.pe_attribute.name, :default_low => ''},
                         :string_data_most_likely => {:pe_attribute_name => am.pe_attribute.name, :default_most_likely => ''},
                         :string_data_high => {:pe_attribute_name => am.pe_attribute.name, :default_high => ''})
              end
            end
          end

        # When project organization exists
        elsif !project_organization.nil?

          # project's organization is deleted and none one is selected
          if @project.organization.nil?
            cap_module_project.estimation_values.delete_all
          end

          # Project's organization has changed
          if !@project.organization.nil? && project_organization != @project.organization
            # Delete all last estimation values for this organization on this project
            cap_module_project.estimation_values.delete_all

            # Create estimation_values for the new selected organization
            @project.organization.attribute_organizations.each do |am|
              ['input', 'output'].each do |in_out|
                mpa = EstimationValue.create(:pe_attribute_id => am.pe_attribute.id,
                         :module_project_id => cap_module_project.id,
                         :in_out => in_out,
                         :is_mandatory => am.is_mandatory,
                         :description => am.pe_attribute.description,
                         :display_order => nil,
                         :string_data_low => {:pe_attribute_name => am.pe_attribute.name, :default_low => ''},
                         :string_data_most_likely => {:pe_attribute_name => am.pe_attribute.name, :default_most_likely => ''},
                         :string_data_high => {:pe_attribute_name => am.pe_attribute.name, :default_high => ''})
              end
            end
          end
        end
      end

      @project.save

      redirect_to redirect(projects_url), notice: "#{I18n.t(:notice_project_successful_updated)}"
    else
      render(:edit)
    end
  end

  def destroy
    @project = Project.find(params[:id])
    case params[:commit]
      when I18n.t('delete')
        if params[:yes_confirmation] == 'selected'
          @project.destroy
          current_user.delete_recent_project(@project.id)
          session[:current_project_id] = current_user.projects.first

          #redirect_to session[:return_to]
          redirect_to projects_path, :notice => I18n.t(:notice_project_successful_deleted, :value => 'Project')
        else
          flash[:warning] = I18n.t('warning_need_check_box_confirmation')
          render :template => 'projects/confirm_deletion'
        end
      when I18n.t('cancel')
        redirect_to projects_path
      else
        render :template => 'projects/confirm_deletion'
    end
  end


  def confirm_deletion
    @project = Project.find(params[:project_id])
  end

  def select_categories
    if params[:project_area_selected].is_numeric?
      @project_area = ProjectArea.find(params[:project_area_selected])
    else
      @project_area = ProjectArea.find_by_name(params[:project_area_selected])
    end

    @project_areas = ProjectArea.all
    @platform_categories = PlatformCategory.all
    @acquisition_categories = AcquisitionCategory.all
    @project_categories = ProjectCategory.all
  end

  #Change selected project ("Jump to a project" select box)
  def change_selected_project
    if params[:project_id]
      session[:current_project_id] = params[:project_id]
    end
    redirect_to '/dashboard'
  end

  #Load specific security depending of user selected (last tabs on project editing page)
  def load_security_for_selected_user
    set_page_title 'Project securities'
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @prj_scrt = ProjectSecurity.find_by_user_id_and_project_id(@user.id, @project.id)
    if @prj_scrt.nil?
      @prj_scrt = ProjectSecurity.create(:user_id => @user.id, :project_id => @project.id)
    end

    respond_to do |format|
      format.js { render :partial => 'projects/run_estimation' }
    end

  end

  #Load specific security depending of user selected (last tabs on project editing page)
  def load_security_for_selected_group
    set_page_title 'Project securities'
    @group = Group.find(params[:group_id])
    @project = Project.find(params[:project_id])
    @prj_scrt = ProjectSecurity.find_by_group_id_and_project_id(@group.id, @project.id)
    if @prj_scrt.nil?
      @prj_scrt = ProjectSecurity.create(:group_id => @user.id, :project_id => @project.id)
    end

    respond_to do |format|
      format.js { render :partial => 'projects/run_estimation' }
    end

  end

  #Updates the security according to the previous users
  def update_project_security_level
    set_page_title 'Project securities'
    @project = Project.find(params[:project_id])
    @user = User.find(params[:user_id].to_i)
    @prj_scrt = ProjectSecurity.find_by_user_id_and_project_id(@user.id, current_project.id)
    @prj_scrt.update_attribute('project_security_level_id', params[:project_security_level])

    respond_to do |format|
      format.js { render :partial => 'projects/run_estimation' }
    end
  end

  #Updates the security according to the previous users
  def update_project_security_level_group
    set_page_title 'Project securities'
    @project = Project.find(params[:project_id])
    @group = Group.find(params[:group_id].to_i)
    @prj_scrt = ProjectSecurity.find_by_group_id_and_project_id(@group.id, current_project.id)
    @prj_scrt.update_attribute('project_security_level_id', params[:project_security_level])

    respond_to do |format|
      format.js { render :partial => 'projects/run_estimation' }
    end

  end

  #Allow o add or append a pemodule to a estimation process
  def append_pemodule
    @project = Project.find(params[:project_id])
    @capitalization_module_project = @capitalization_module.nil? ? nil : @project.module_projects.find_by_pemodule_id(@capitalization_module.id)

    if params[:pbs_project_element_id] && params[:pbs_project_element_id] != ''
      @pbs_project_element = PbsProjectElement.find(params[:pbs_project_element_id])
    else
      @pbs_project_element = @project.root_component
    end

    unless params[:module_selected].nil? || @project.nil?
      @array_modules = Pemodule.all
      @pemodules ||= Pemodule.all

      #Max pos or 1
      @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
      @module_positions_x = ModuleProject.where(:project_id => @project.id).all.map(&:position_x).uniq.max

      #When adding a module in the "timeline", it creates an entry in the table ModuleProject for the current project, at position 2 (the one being reserved for the input module).
      my_module_project = ModuleProject.new(:project_id => @project.id, :pemodule_id => params[:module_selected], :position_y => 1, :position_x => @module_positions_x.to_i+1)
      my_module_project.save

      @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
      @module_positions_x = ModuleProject.where(:project_id => @project.id).all.map(&:position_x).uniq.max

      #For each attribute of this new ModuleProject, it copy in the table ModuleAttributeProject, the attributes of modules.
      # TODO Now only one record is created for the couple (module, attribute) : value for each PBS is serialize in only one string
      my_module_project.pemodule.attribute_modules.each do |am|
        if am.in_out == 'both'
          ['input', 'output'].each do |in_out|
            mpa = EstimationValue.create(:pe_attribute_id => am.pe_attribute.id,
                     :module_project_id => my_module_project.id,
                     :in_out => in_out,
                     :is_mandatory => am.is_mandatory,
                     :description => am.description,
                     :display_order => am.display_order,
                     :string_data_low => {:pe_attribute_name => am.pe_attribute.name, :default_low => am.default_low},
                     :string_data_most_likely => {:pe_attribute_name => am.pe_attribute.name, :default_most_likely => am.default_most_likely},
                     :string_data_high => {:pe_attribute_name => am.pe_attribute.name, :default_high => am.default_high},
                     :custom_attribute => am.custom_attribute,
                     :project_value => am.project_value)
          end
        else
          mpa = EstimationValue.create(:pe_attribute_id => am.pe_attribute.id,
                     :module_project_id => my_module_project.id,
                     :in_out => am.in_out,
                     :is_mandatory => am.is_mandatory,
                     :display_order => am.display_order,
                     :description => am.description,
                     :string_data_low => {:pe_attribute_name => am.pe_attribute.name, :default_low => am.default_low},
                     :string_data_most_likely => {:pe_attribute_name => am.pe_attribute.name, :default_most_likely => am.default_most_likely},
                     :string_data_high => {:pe_attribute_name => am.pe_attribute.name, :default_high => am.default_high},
                     :custom_attribute => am.custom_attribute,
                     :project_value => am.project_value)
        end
      end

      #Link capitalization module to other modules
      unless @capitalization_module.nil?
        my_module_project.update_attribute('associated_module_project_ids', @capitalization_module_project.id) unless @capitalization_module_project.nil?
      end
    end
  end

  def select_pbs_project_elements
    @project = Project.find(params[:project_id])
    if params[:pbs_project_element_id] && params[:pbs_project_element_id] != ''
      @pbs_project_element = PbsProjectElement.find(params[:pbs_project_element_id])
    else
      @pbs_project_element = @project.root_component
    end
    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
    @module_positions_x = ModuleProject.where(:project_id => @project.id).all.map(&:position_x).uniq.max
  end


  def read_tree_nodes(current_node)
    ordered_list_of_nodes = Array.new
    next_nodes = current_node.next.sort{|node1, node2| (node1.position_y <=> node2.position_y) && (node1.position_x <=> node2.position_x)}.uniq
    ordered_list_of_nodes = ordered_list_of_nodes + next_nodes
    ordered_list_of_nodes.uniq

    next_nodes.each do |n|
      read_tree_nodes(n)
    end
  end

  # Breadth-First Traversal of a Tree
  # This function list the next module_projects according to the given (starting_node) module_project
  # compatibility between the module_projects with the current_component is verified
  # Then return the module_projects like Tree Breadth
  def crawl_module_project(starting_node)
    pbs_project_element = current_component
    list = []
    items=[starting_node]
    until items.empty?
      # Returns the first element of items and removes it (shifting all other elements down by one).
      item = items.shift

      # Get all next module_projects that are linked to the current item
      list << item unless list.include?(item)
      kids = item.next.select { |i| i.pbs_project_elements.map(&:id).include?(pbs_project_element.id) }
      kids = kids.sort{ |mp1, mp2| (mp1.position_y <=> mp2.position_y) && (mp1.position_x <=> mp2.position_x)} #Get next module_project

      kids.each{ |kid| items << kid }
    end
    list - [starting_node]
  end


  #Run estimation process
  def run_estimation(start_module_project = nil, rest_of_module_projects = nil, set_attributes = nil, input_data_params = nil)
    @project = current_project
    @pbs_project_element = current_component
    @my_results = Hash.new
    @last_estimation_results = Hash.new
    set_attributes_name_list = { :low => [], :high => [], :most_likely => [] }

    if start_module_project.nil?
      start_module_project = current_module_project
      rest_of_module_projects = crawl_module_project(current_module_project)
      start_mp_params = params
      ['low', 'most_likely', 'high'].each do |level|
        start_mp_params[level].each do |key, hash|
          start_mp_params[level][key] = hash[current_module_project.id.to_s]
        end
      end
      input_data_params = start_mp_params
      set_attributes = {:low => {}, :most_likely => {}, :high => {} }
    end

    # Execution of the first/current module-project
    ['low', 'most_likely', 'high'].each do |level|
      @my_results[level.to_sym] = run_estimation_plan(input_data_params, level, @project, start_module_project)
    end

    #Save output values: only for current pbs_project_element and for current module-project
    save_estimation_result(start_module_project, set_attributes, @my_results)

    # Need to execute other module_projects if all required input attributes are present
    # Get all required attributes for each module (where)
    # Get all module_projects from the current_module_project : crawl_module_project(start_module_project)
    until rest_of_module_projects.empty?
      module_project = rest_of_module_projects.shift     ###  crawl_module_project(current_module_project).each do |module_project|

      @module_project_results = Hash.new
      required_input_attributes = Array.new
      input_attribute_modules = module_project.estimation_values.where('in_out IN (?) AND is_mandatory = ?', %w(input both), true)
      input_attribute_modules.each do |attr_module|
        required_input_attributes << attr_module.pe_attribute.alias
      end

      # Verification will be done only if there are some required attribute for the module
      #unless required_input_attributes.empty?
      # Re-initialize the current module_project
      # @my_results is like that {:low => {:complexity_467 => 'organic', :ksloc_467 => 10}, :most_likely => {:complexity_467 => 'organic', :ksloc_467 => 10}, :hight => {:complexity_467 => 'organic', :ksloc_467 => 10}}
      get_all_required_attributes = []

      ['low', 'most_likely', 'high'].each do |level|
        level_result = @my_results[level.to_sym]

        level_result.each do |key, value|
          attribute_alias = key.to_s.split("_#{start_module_project.id}").first
          set_attributes[level.to_sym][attribute_alias.to_sym] = value      #{ "#{current_module_project.id}".to_sym => value }
        end

        # Update the set_attributes_name_list with the last one,
        # Attribute is only added to the set_attributes_name_list if it's present
        set_attributes[level.to_sym].keys.each { |key| set_attributes_name_list[level.to_sym] << key.to_s }

        # Need to verify that all required attributes for this module are present
        # If all required attributes are present
        get_all_required_attributes << ((required_input_attributes & set_attributes_name_list[level.to_sym]) == required_input_attributes)
      end

      at_least_one_all_required_attr = nil
      get_all_required_attributes.each do |elt|
        at_least_one_all_required_attr = elt
        break if at_least_one_all_required_attr == true
      end

      #Run the estimation until there is one module_project that doesn't has all required attributes
      catch (:done) do
        # Run estimation plan for the current module_project
        throw :done if !at_least_one_all_required_attr

        run_estimation(module_project, rest_of_module_projects, set_attributes, input_data_params)
      end
    end

    puts "test ça"

    respond_to do |format|
      format.js { render :partial => 'pbs_project_elements/refresh'}
    end
  end


  # Function that save current module_project estimation result in DB
  #Save output values: only for current pbs_project_element
  def save_estimation_result(start_module_project, input_attributes, output_data)
    @pbs_project_element = current_component

    # get the estimation_value for the current_pbs_project_element
    current_pbs_estimations = start_module_project.estimation_values
    current_pbs_estimations.each do |est_val|
      est_val_attribute_alias = est_val.pe_attribute.alias
      est_val_attribute_type = est_val.pe_attribute.attribute_type
      if est_val.in_out == 'output'
        out_result = Hash.new
        @my_results.each do |res|
          ['low', 'most_likely', 'high'].each do |level|
            # We don't have to replace the value, but we need to update them
            level_estimation_value = Hash.new
            level_estimation_value = est_val.send("string_data_#{level}")
            level_estimation_value_without_consistency = @my_results[level.to_sym]["#{est_val_attribute_alias}_#{start_module_project.id.to_s}".to_sym]

            # In case when module use the wbs_project_element, the is_consistent need to be set
            if start_module_project.pemodule.yes_for_output_with_ratio? || start_module_project.pemodule.yes_for_output_without_ratio? || start_module_project.pemodule.yes_for_input_output_with_ratio? || start_module_project.pemodule.yes_for_input_output_without_ratio?
              psb_level_estimation = level_estimation_value[@pbs_project_element.id]
              level_estimation_value[@pbs_project_element.id] = set_element_value_with_activities(level_estimation_value_without_consistency, start_module_project)
            else
              level_estimation_value[@pbs_project_element.id] = level_estimation_value_without_consistency
            end

            out_result["string_data_#{level}"] = level_estimation_value
          end

          # compute the probable value for each node
          probable_estimation_value = Hash.new
          probable_estimation_value = est_val.send('string_data_probable')

          if est_val_attribute_type == 'numeric'
            probable_estimation_value[@pbs_project_element.id] = probable_value(@my_results, est_val)
          else
            probable_estimation_value[@pbs_project_element.id] = @my_results[:most_likely]["#{est_val_attribute_alias}_#{est_val.module_project_id.to_s}".to_sym]
          end

          out_result['string_data_probable'] = probable_estimation_value
        end

        est_val.update_attributes(out_result)

      elsif est_val.in_out == 'input'
        in_result = Hash.new

        ['low', 'most_likely', 'high'].each do |level|
          level_estimation_value = Hash.new
          level_estimation_value = est_val.send("string_data_#{level}")
          begin
            start_module_project == current_module_project ? pbs_level_form_input = params[level][est_val_attribute_alias]
                                                           : pbs_level_form_input = input_attributes[level.to_sym][est_val_attribute_alias.to_sym]#[start_module_project.id.to_s]
          rescue
            start_module_project == current_module_project ? pbs_level_form_input = params[est_val_attribute_alias]
                                                           : pbs_level_form_input = input_attributes[est_val_attribute_alias.to_sym]
          end

          wbs_root = start_module_project.project.pe_wbs_projects.activities_wbs.first.wbs_project_elements.where('is_root = ?', true).first
          if start_module_project.pemodule.yes_for_input? || start_module_project.pemodule.yes_for_input_output_with_ratio? || start_module_project.pemodule.yes_for_input_output_without_ratio?
            unless start_module_project.pemodule.alias == 'effort_balancing'
              level_estimation_value[@pbs_project_element.id] = compute_tree_node_estimation_value(wbs_root, pbs_level_form_input)
            end
          else
            level_estimation_value[@pbs_project_element.id] = pbs_level_form_input
          end

          in_result["string_data_#{level}"] = level_estimation_value

        end
        est_val.update_attributes(in_result)
      end
    end
  end


  #Run estimation process
  def run_estimation_SAVE
    @module_projects = current_project.module_projects
    @project = current_project
    @pbs_project_element = current_component
    @my_results = Hash.new
    @set_attributes = Hash.new

    ['low', 'most_likely', 'high'].each do |level|
      #@my_results[level.to_sym] = run_estimation_plan(params, level, @project)
      @my_results[level.to_sym] = run_estimation_plan(params, level, @project, current_module_project)
    end

    #Get all module_projects from the current_module_project
    current_next_module_projects = current_module_project.following.select { |i| i.pbs_project_elements.map(&:id).include?(@pbs_project_element.id) }
    current_next_compatible_module_projects = current_next_module_projects.sort{ |mp1, mp2| mp1.position_y <=> mp2.position_y}

    #Get all required attributes for each module (where )
    current_next_compatible_module_projects.each do |module_project|
      required_input_attributes = Array.new
      input_attribute_modules = module_project.pemodule.attribute_modules.where('in_out IN (?) AND is_mandatory = ?', %w(input both), true)
      input_attribute_modules.each do |attr_module|
        required_input_attributes << attr_module.pe_attribute
      end
    end

    puts "test ça"

    #Save output values: only for current pbs_project_element
    #@project.module_projects.select { |i| i.pbs_project_elements.map(&:id).include?(@pbs_project_element.id) }.each do |mp|
    # get the estimation_value for the current_pbs_project_element
    current_pbs_estimations = current_module_project.estimation_values
    current_pbs_estimations.each do |est_val|
      est_val_attribute_alias = est_val.pe_attribute.alias
      est_val_attribute_type = est_val.pe_attribute.attribute_type
      if est_val.in_out == 'output'
        out_result = Hash.new
        @my_results.each do |res|
          ['low', 'most_likely', 'high'].each do |level|
            # We don't have to replace the value, but we need to update them
            level_estimation_value = Hash.new
            level_estimation_value = est_val.send("string_data_#{level}")
            level_estimation_value_without_consistency = @my_results[level.to_sym]["#{est_val_attribute_alias}_#{current_module_project.id.to_s}".to_sym]

            # In case when module use the wbs_project_element, the is_consistent need to be set
            if current_module_project.pemodule.yes_for_output_with_ratio? || current_module_project.pemodule.yes_for_output_without_ratio? || current_module_project.pemodule.yes_for_input_output_with_ratio? || current_module_project.pemodule.yes_for_input_output_without_ratio?
              psb_level_estimation = level_estimation_value[@pbs_project_element.id]
              level_estimation_value[@pbs_project_element.id] = set_element_value_with_activities(level_estimation_value_without_consistency, current_module_project)
            else
              level_estimation_value[@pbs_project_element.id] = level_estimation_value_without_consistency
            end

            out_result["string_data_#{level}"] = level_estimation_value
          end

          # compute the probable value for each node
          probable_estimation_value = Hash.new
          probable_estimation_value = est_val.send('string_data_probable')

          if est_val_attribute_type == 'numeric'
            probable_estimation_value[@pbs_project_element.id] = probable_value(@my_results, est_val)
          else
            probable_estimation_value[@pbs_project_element.id] = @my_results[:most_likely]["#{est_val_attribute_alias}_#{est_val.module_project_id.to_s}".to_sym]
          end

          out_result['string_data_probable'] = probable_estimation_value
        end

        est_val.update_attributes(out_result)

      elsif est_val.in_out == 'input'
        in_result = Hash.new
        ['low', 'most_likely', 'high'].each do |level|
          level_estimation_value = Hash.new
          level_estimation_value = est_val.send("string_data_#{level}")
          begin
            pbs_level_form_input = params[level][est_val_attribute_alias.to_sym][current_module_project.id.to_s]
          rescue
            pbs_level_form_input = params[est_val_attribute_alias.to_sym][current_module_project.id.to_s]
          end

          wbs_root = current_module_project.project.pe_wbs_projects.activities_wbs.first.wbs_project_elements.where('is_root = ?', true).first
          if current_module_project.pemodule.yes_for_input? || current_module_project.pemodule.yes_for_input_output_with_ratio? || current_module_project.pemodule.yes_for_input_output_without_ratio?
            unless current_module_project.pemodule.alias == 'effort_balancing'
              level_estimation_value[@pbs_project_element.id] = compute_tree_node_estimation_value(wbs_root, pbs_level_form_input)
            end
          else
            level_estimation_value[@pbs_project_element.id] = pbs_level_form_input
          end

          in_result["string_data_#{level}"] = level_estimation_value

        end
        est_val.update_attributes(in_result)
      end
    end
    #end

    respond_to do |format|
      format.js { render :partial => 'pbs_project_elements/refresh' }
    end
  end


  # Compute the input element value
  ## values_to_set : Hash
  def compute_tree_node_estimation_value(tree_root, values_to_set)
    WbsProjectElement.rebuild_depth_cache!
    new_effort_man_hour = Hash.new

    tree_root.children.each do |node|
      # Sort node subtree by ancestry_depth
      sorted_node_elements = node.subtree.order('ancestry_depth desc')
      sorted_node_elements.each do |wbs_project_element|
        if wbs_project_element.is_childless?
          new_effort_man_hour[wbs_project_element.id] = values_to_set[wbs_project_element.id.to_s]
        else
          new_effort_man_hour[wbs_project_element.id] = compact_array_and_compute_node_value(wbs_project_element, new_effort_man_hour)
        end
      end
    end

    new_effort_man_hour[tree_root.id] = compact_array_and_compute_node_value(tree_root, new_effort_man_hour) ###root_element_effort_man_hour
    new_effort_man_hour
  end

  #This method set result in DB with the :value key for node estimation value
  def set_element_value_with_activities(estimation_result, module_project)
    result_with_consistency = Hash.new
    consistency = true
    if !estimation_result.nil? && !estimation_result.eql?('-')
      estimation_result.each do |wbs_project_elt_id, est_value|
        if module_project.pemodule.alias == 'wbs_activity_completion'
          wbs_project_elt = WbsProjectElement.find(wbs_project_elt_id)
          if wbs_project_elt.has_new_complement_child?
            consistency =  set_wbs_completion_node_consistency(estimation_result, wbs_project_elt)
          end
          result_with_consistency[wbs_project_elt_id] = {:value => est_value, :is_consistent => consistency}
        elsif module_project.pemodule.alias == 'effort_balancing'
          result_with_consistency[wbs_project_elt_id] = {:value => est_value}
        else
          result_with_consistency[wbs_project_elt_id] = {:value => est_value}
        end

      end
    else
      result_with_consistency = nil
    end

    result_with_consistency
  end


  # After estimation, need to know if node value are consistent or not for WBS-Completion modules
  def set_wbs_completion_node_consistency(estimation_result, wbs_project_element)
    consistency = true
    estimation_result_without_null_value = []

    wbs_project_element.child_ids.each do |child_id|
      value = estimation_result[child_id]
      if value.is_a?(Float) or value.is_a?(Integer)
        estimation_result_without_null_value <<  value
      end
    end
    if estimation_result[wbs_project_element.id].to_f != estimation_result_without_null_value.sum.to_f
      consistency = false
    end
    consistency
  end


  # TODO: Verify if it still being used ... Unless DELETE function from code
  # After estimation, need to know if node value are consistent or not
  def set_element_consistency(estimation_result, module_project)
    result_with_consistency = Hash.new
    #unless estimation_result.nil? || estimation_result.eql?("-")
    if !estimation_result.nil? && !estimation_result.eql?('-')
      estimation_result.each do |wbs_project_elt_id, est_value|
        consistency = true
        wbs_project_element = WbsProjectElement.find(wbs_project_elt_id)
        if wbs_project_element.has_children?
          if !module_project.pemodule.alias.to_s == 'effort_breakdown' && wbs_project_element.has_new_complement_child?
            children_est_value = 0.0
            wbs_project_element.child_ids.each do |child_id|
              children_est_value = children_est_value + estimation_result[child_id].to_f
            end
            if est_value.to_f != children_est_value.to_f
              consistency = false
            end
          end
        end
        result_with_consistency[wbs_project_elt_id] = {:value => est_value, :is_consistent => consistency}
      end
    else
      result_with_consistency = nil
    end

    result_with_consistency
  end


  # This estimation plan method is called for each component
  def run_estimation_plan(input_data, level, project, current_mp_to_execute)
    @result_hash = Hash.new
    inputs = Hash.new

    #project.module_projects.select { |i| i.pbs_project_elements.map(&:id).include?(current_component.id) }.each do |module_project|
      current_mp_to_execute.estimation_values.sort! { |a, b| a.in_out <=> b.in_out }.each do |est_val|
        if est_val.in_out == 'input' or est_val.in_out=='both'
          if current_mp_to_execute.pemodule.alias == 'effort_balancing'
            inputs[est_val.pe_attribute.alias.to_sym] = input_data[est_val.pe_attribute.alias]#[current_mp_to_execute.id.to_s]
          else
            inputs[est_val.pe_attribute.alias.to_sym] = input_data[level][est_val.pe_attribute.alias]#[current_mp_to_execute.id.to_s]
          end
        end

        current_pbs_project_elt = current_component
        current_module = "#{current_mp_to_execute.pemodule.alias.camelcase.constantize}::#{current_mp_to_execute.pemodule.alias.camelcase.constantize}".gsub(' ', '').constantize

        #Need to add input for pbs_project_element and module_project
        inputs['pbs_project_element_id'.to_sym] = current_pbs_project_elt.id
        inputs['module_project_id'.to_sym] = current_mp_to_execute.id
        inputs['pe_attribute_alias'.to_sym] = est_val.pe_attribute.alias

        # Normally, the input data is commonly from the Expert Judgment Module on PBS (when running estimation on its product)
        cm = current_module.send(:new, inputs)

        if est_val.in_out == 'output' or est_val.in_out=='both'
          begin
            @result_hash["#{est_val.pe_attribute.alias}_#{current_mp_to_execute.id}".to_sym] = cm.send("get_#{est_val.pe_attribute.alias}")
          rescue Exception => e
            @result_hash["#{est_val.pe_attribute.alias}_#{current_mp_to_execute.id}".to_sym] = nil
            puts e.message
          end
        end
      end
    @result_hash
  end


  #Method to duplicate project and associated pe_wbs_project
  def duplicate
    begin
      old_prj = Project.find(params[:project_id])

      new_prj = old_prj.amoeba_dup #amoeba gem is configured in Project class model

      if new_prj.save
        old_prj.save #Original project copy number will be incremented to 1

        #Managing the component tree : PBS
        pe_wbs_product = new_prj.pe_wbs_projects.products_wbs.first
        pe_wbs_activity = new_prj.pe_wbs_projects.activities_wbs.first

        # For PBS
        new_prj_components = pe_wbs_product.pbs_project_elements
        new_prj_components.each do |new_c|
          unless new_c.is_root?
            new_ancestor_ids_list = []
            new_c.ancestor_ids.each do |ancestor_id|
              ancestor_id = PbsProjectElement.find_by_pe_wbs_project_id_and_copy_id(new_c.pe_wbs_project_id, ancestor_id).id
              new_ancestor_ids_list.push(ancestor_id)
            end
            new_c.ancestry = new_ancestor_ids_list.join('/')

            # For PBS-Project-Element Links with modules
            old_pbs = PbsProjectElement.find(new_c.copy_id)
            new_c.module_projects = old_pbs.module_projects

            new_c.save
          end
        end

        # For WBS
        new_prj_wbs = pe_wbs_activity.wbs_project_elements
        new_prj_wbs.each do |new_wbs|
          unless new_wbs.is_root?
            new_ancestor_ids_list = []
            new_wbs.ancestor_ids.each do |ancestor_id|
              ancestor_id = WbsProjectElement.find_by_pe_wbs_project_id_and_copy_id(new_wbs.pe_wbs_project_id, ancestor_id).id
              new_ancestor_ids_list.push(ancestor_id)
            end
            new_wbs.ancestry = new_ancestor_ids_list.join('/')
            new_wbs.save
          end
        end

        # For ModuleProject associations
        old_prj.module_projects.group(:id).each do |old_mp|
          new_mp = ModuleProject.find_by_project_id_and_copy_id(new_prj.id, old_mp.id)
          old_mp.associated_module_projects.each do |associated_mp|
            new_associated_mp = ModuleProject.where('project_id = ? AND copy_id = ?', new_prj.id, associated_mp.id).first
            new_mp.associated_module_projects <<  new_associated_mp
          end
        end

        #raise "#{RuntimeError}"
      end

      flash[:success] = I18n.t(:notice_project_successful_duplicated)
      redirect_to '/projects' and return
    rescue
      flash['Error'] = I18n.t(:error_project_duplication_failed)
      redirect_to '/projects'
    end
  end


  def commit
    project = Project.find(params[:project_id])
    project.commit!
    redirect_to '/projects'
  end

  def activate
    u = current_user
    u.add_recent_project(params[:project_id])
    session[:current_project_id] = params[:project_id]
    redirect_to '/projects'
  end

  def find_use_project
    @project = Project.find(params[:project_id])
    @related_projects = Array.new
    @related_projects_inverse = Array.new

    unless @project.nil?
      related_pe_wbs_project = @project.pe_wbs_projects.products_wbs
      related_pbs_projects = PbsProjectElement.where(:pe_wbs_project_id => related_pe_wbs_project)
      unless related_pe_wbs_project.empty?
        related_pbs_projects.each do |pbs|
          unless pbs.project_link.nil? or pbs.project_link.blank?
            p = Project.find_by_id(pbs.project_link)
            @related_projects << p
          end
        end
      end
    end

    related_pbs_project_elements = PbsProjectElement.where('project_link IN (?)',  [params[:project_id]]).all
    related_pbs_project_elements.each do |i|
      @related_projects_inverse << i.pe_wbs_project.project
    end

    @related_users = @project.users
    @related_groups = @project.groups
  end

  def projects_global_params
    set_page_title 'Project global parameters'
  end

  def sort_column
    Project.column_names.include?(params[:sort]) ? params[:sort] : 'title'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def default_work_element_type
    wet = WorkElementType.find_by_alias('folder')
    return wet
  end

  #Add/Import a WBS-Activity template from Library to Project
  def add_wbs_activity_to_project
    @project = Project.find(params[:project_id])
    @pe_wbs_project_activity = @project.pe_wbs_projects.activities_wbs.first
    @wbs_project_elements_root = @project.wbs_project_element_root

    selected_wbs_activity_elt = WbsActivityElement.find(params[:wbs_activity_element])

    wbs_project_element = WbsProjectElement.new(:pe_wbs_project_id => @pe_wbs_project_activity.id, :wbs_activity_element_id => selected_wbs_activity_elt.id,
                                                :wbs_activity_id => selected_wbs_activity_elt.wbs_activity_id, :name => selected_wbs_activity_elt.name,
                                                :description => selected_wbs_activity_elt.description, :ancestry => @wbs_project_elements_root.id,
                                                :author_id => current_user.id, :copy_number => 0,
                                                :wbs_activity_ratio_id => params[:project_default_wbs_activity_ratio], # Update Project default Wbs-Activity-Ratio
                                                :is_added_wbs_root => true)

    selected_wbs_activity_children = selected_wbs_activity_elt.children

    respond_to do |format|
      #wbs_project_element.transaction do
      if wbs_project_element.save
        selected_wbs_activity_children.each do |child|
          create_wbs_activity_from_child(child, @pe_wbs_project_activity, @wbs_project_elements_root)
        end

        #add some additional information for leaf element customization
        added_wbs_project_elements = WbsProjectElement.find_all_by_wbs_activity_id_and_pe_wbs_project_id(wbs_project_element.wbs_activity_id, @pe_wbs_project_activity.id)
        added_wbs_project_elements.each do |project_elt|
          if project_elt.has_children?
            project_elt.can_get_new_child = false
          else
            project_elt.can_get_new_child = true
          end
          project_elt.save
        end

        @project.included_wbs_activities.push(wbs_project_element.wbs_activity_id)
        if @project.save
          flash[:notice] = I18n.t(:notice_wbs_activity_successful_added)
        else
          flash[:error] = "#{@project.errors.full_messages.to_sentence}"
        end
      else
        flash[:error] = "#{wbs_project_element.errors.full_messages.to_sentence}"
      end
      #end
      format.html { redirect_to edit_project_path(@project, :anchor => 'tabs-3') }
      format.js { redirect_to edit_project_path(@project, :anchor => 'tabs-3') }
    end
  end

  def get_new_ancestors(node, pe_wbs_activity, wbs_elt_root)
    node_ancestors = node.ancestry.split('/')
    new_ancestors = []
    new_ancestors << wbs_elt_root.id
    node_ancestors.each do |ancestor|
      corresponding_wbs_project = WbsProjectElement.where('wbs_activity_element_id = ? and pe_wbs_project_id = ?', ancestor, pe_wbs_activity.id).first
      new_ancestors << corresponding_wbs_project.id
    end
    new_ancestors.join('/')
  end

  def create_wbs_activity_from_child(node, pe_wbs_activity, wbs_elt_root)
    wbs_project_element = WbsProjectElement.new(:pe_wbs_project_id => pe_wbs_activity.id, :wbs_activity_element_id => node.id, :wbs_activity_id => node.wbs_activity_id, :name => node.name,
                                                :description => node.description, :ancestry => get_new_ancestors(node, pe_wbs_activity, wbs_elt_root), :author_id => current_user.id, :copy_number => 0)
    wbs_project_element.transaction do
      wbs_project_element.save

      if node.has_children?
        node_children = node.children
        node_children.each do |node_child|
          ActiveRecord::Base.transaction do
            create_wbs_activity_from_child(node_child, pe_wbs_activity, wbs_elt_root)
          end
        end
      end
    end
  end

  def refresh_wbs_project_elements
    @project = Project.find(params[:project_id])
    @pe_wbs_project_activity = @project.pe_wbs_projects.activities_wbs.first
    @show_hidden = params[:show_hidden]
  end

  #On edit page, select ratios according to the selected wbs_activity
  def refresh_wbs_activity_ratios
    if params[:wbs_activity_element_id].empty? || params[:wbs_activity_element_id].nil?
      @wbs_activity_ratios = []
    else
      selected_wbs_activity_elt = WbsActivityElement.find(params[:wbs_activity_element_id])
      @wbs_activity = selected_wbs_activity_elt.wbs_activity
      @wbs_activity_ratios = @wbs_activity.wbs_activity_ratios
    end
  end

  def choose_project
    u = current_user
    u.add_recent_project(params[:project_id])
    session[:current_project_id] = params[:project_id]
    redirect_to root_url
  end

  def locked_plan
    @project = Project.find(params[:project_id])
    @project.locked? ? @project.is_locked = false : @project.is_locked = true
    @project.save
    redirect_to edit_project_path(@project, :anchor => 'tabs-4')
  end

  def projects_from
    @projects = Project.where(:is_model => true)
  end

end
