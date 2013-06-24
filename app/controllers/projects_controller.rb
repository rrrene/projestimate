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
    respond_to do |format|
      format.html
      format.js {
        render :partial => 'project_record_number'
      }
    end
  end

  def new
    set_page_title 'New project'
  end

  #Create a new project
  def create
    set_page_title 'Create project'
    @project = Project.new(params[:project])
    @wbs_activity_elements = []

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

          if current_user.groups.map(&:code_group).include? ('super_admin')
            current_user.project_ids = current_user.project_ids.push(@project.id)
            current_user.save
          end

          redirect_to redirect(projects_url), notice: "#{I18n.t(:notice_project_successful_created)}"
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
    authorize! :edit_a_project, Project
    set_page_title 'Edit project'

    @project = Project.find(params[:id])

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

    if @project.update_attributes(params[:project])
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
          redirect_to projects_path, :notice => I18n.t(:notice_successfully_deleted, :value => "Project")
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
      #@project.pe_wbs_projects.products_wbs.first.pbs_project_elements.each do |c|
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
      #end
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

  #Run estimation process
  def run_estimation
    @result = Array.new
    results = Hash.new
    @module_projects = current_project.module_projects
    @project = current_project
    @pbs_project_element = current_component

    ['low', 'most_likely', 'high'].each do |level|
      results[level.to_sym] = run_estimation_plan(params, level, @project)
    end

    @results = results

    #Save output values: only for current pbs_project_element
    @project.module_projects.select { |i| i.pbs_project_elements.map(&:id).include?(@pbs_project_element.id) }.each do |mp|
      # get the estimation_value for the current_pbs_project_element
      current_pbs_estimations = mp.estimation_values
      current_pbs_estimations.each do |est_val|
        est_val_attribute_alias = est_val.pe_attribute.alias
        est_val_attribute_type = est_val.pe_attribute.attribute_type
        if est_val.in_out == 'output'
          out_result = Hash.new
          @results.each do |res|
            ['low', 'most_likely', 'high'].each do |level|
              # We don't have to replace the value, but we need to update them
              level_estimation_value = Hash.new
              level_estimation_value = est_val.send("string_data_#{level}")
              ##level_estimation_value[@pbs_project_element.id] = @results[level.to_sym]["#{est_val.pe_attribute.alias}_#{mp.id.to_s}".to_sym]
              level_estimation_value_without_consistency = @results[level.to_sym]["#{est_val_attribute_alias}_#{mp.id.to_s}".to_sym]

              # In case when module use the wbs_project_element, the is_consistent need to be set
              if mp.pemodule.yes_for_output_with_ratio? || mp.pemodule.yes_for_output_without_ratio? || mp.pemodule.yes_for_input_output_with_ratio? || mp.pemodule.yes_for_input_output_without_ratio?
                psb_level_estimation = level_estimation_value[@pbs_project_element.id]
                level_estimation_value[@pbs_project_element.id] = set_element_value_with_activities(level_estimation_value_without_consistency, mp)
              else
                level_estimation_value[@pbs_project_element.id] = level_estimation_value_without_consistency
              end

              out_result["string_data_#{level}"] = level_estimation_value
            end

            # compute the probable value for each node
            probable_estimation_value = Hash.new
            probable_estimation_value = est_val.send('string_data_probable')

            if est_val_attribute_type == 'numeric'
              probable_estimation_value[@pbs_project_element.id] = probable_value(@results, est_val)
            else
              probable_estimation_value[@pbs_project_element.id] = @results[:most_likely]["#{est_val_attribute_alias}_#{est_val.module_project_id.to_s}".to_sym]
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
              pbs_level_form_input = params[level][est_val_attribute_alias.to_sym][mp.id.to_s]
            rescue
              pbs_level_form_input = params[est_val_attribute_alias.to_sym][mp.id.to_s]
            end

            wbs_root = mp.project.pe_wbs_projects.activities_wbs.first.wbs_project_elements.where('is_root = ?', true).first
            if mp.pemodule.yes_for_input? || mp.pemodule.yes_for_input_output_with_ratio? || mp.pemodule.yes_for_input_output_without_ratio?
              unless mp.pemodule.alias == 'effort_balancing'
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


  # After estimation, need to know if node value are consistent or not for WBS-Completion module
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
  def run_estimation_plan(input_data, level, project)
    @result_array = Array.new
    @result_hash = Hash.new
    inputs = Hash.new

    project.module_projects.select { |i| i.pbs_project_elements.map(&:id).include?(current_component.id) }.each do |module_project|
      module_project.estimation_values.sort! { |a, b| a.in_out <=> b.in_out }.each do |est_val|
        if est_val.in_out == 'input' or est_val.in_out=='both'
          if module_project.pemodule.alias == 'effort_balancing'
            inputs[est_val.pe_attribute.alias.to_sym] = input_data[est_val.pe_attribute.alias][module_project.id.to_s]
          else
            inputs[est_val.pe_attribute.alias.to_sym] = input_data[level][est_val.pe_attribute.alias][module_project.id.to_s]
          end

        end

        current_pbs_project_elt = current_component
        current_module = "#{module_project.pemodule.alias.camelcase.constantize}::#{module_project.pemodule.alias.camelcase.constantize}".gsub(' ', '').constantize

        #Need to add input for pbs_project_element and module_project
        inputs['pbs_project_element_id'.to_sym] = current_pbs_project_elt.id
        inputs['module_project_id'.to_sym] = module_project.id

        # Normally, the input data is commonly from the Expert Judgment Module on PBS (when running estimation on its product)
        cm = current_module.send(:new, inputs)

        if est_val.in_out == 'output' or est_val.in_out=='both'
          begin
            @result_hash["#{est_val.pe_attribute.alias}_#{module_project.id}".to_sym] = cm.send("get_#{est_val.pe_attribute.alias}")
          rescue Exception => e
            @result_hash["#{est_val.pe_attribute.alias}_#{module_project.id}".to_sym] = nil
            puts e.message
          end
        end
      end
    end

    puts "RESULT_HASH [#{level}] = #{@result_hash}" #Ex: RESULT_HASH = {:effort_man_hour=>{"337"=>18000.0, "338"=>12000.0}}
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
            new_associated_mp = ModuleProject.where("project_id = ? AND copy_id = ?", new_prj.id, associated_mp.id).first
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
    unless @project.nil?
      @related_pe_wbs_project= @project.pe_wbs_projects.wbs_product

      @related_pbs_projects = PbsProjectElement.find_all_by_pe_wbs_project_id(@related_pe_wbs_project)

      @related_projects = []
      unless @related_pbs_projects.empty?
       @related_pbs_projects.each do |pbs|
            unless pbs.project_link.nil?
              @related_projects << Project.find_by_id(pbs.project_link)
            end
       end
      end
    end





    #respond_to do |format|
    #  format.js { render :partial => 'projects/find_use' }
    #end
   puts "toto"
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

end
