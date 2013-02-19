#encoding: utf-8
#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012 Spirula (http://www.spirula.fr)
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
  helper_method :sort_column
  helper_method :sort_direction

  before_filter :load_data, :only => [:update, :edit, :new, :create]
  before_filter :get_record_statuses

  def load_data
    if params[:id]
      @project = Project.find(params[:id])
    else
      @project = Project.new :state => "preliminary"
    end
    @user = @project.users.first
    @project_areas = ProjectArea.all
    @platform_categories = PlatformCategory.all
    @acquisition_categories = AcquisitionCategory.all
    @project_categories = ProjectCategory.all
    @pemodules ||= Pemodule.all
    @project_modules = @project.pemodules
    @array_module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
    @organizations = Organization.all
    @project_modules = @project.pemodules
    @project_security_levels = ProjectSecurityLevel.all
    @module_project = ModuleProject.find_by_project_id(@project.id)
  end

  def index
    set_page_title "Projects"
    @projects = Project.page(params[:page]).per_page(5)
    respond_to do |format|
      format.html
      format.js {
        render :partial => "project_record_number"
      }
    end
  end

  def new
    set_page_title "New project"
  end

  #Create a new project
  def create
    set_page_title "Create project"
    @project = Project.new(params[:project])

    begin
      @project.transaction do
        if @project.save
          #New default Pe-Wbs-Project
          pe_wbs_project_product  = @project.pe_wbs_projects.build(:name => "#{@project.title} WBS-Product - Product Breakdown Structure", :wbs_type => "Product")
          pe_wbs_project_activity = @project.pe_wbs_projects.build(:name => "#{@project.title} WBS-Activity - Activity breakdown Structure", :wbs_type => "Activity")

          if pe_wbs_project_product.save
            ##New root Pbs-Project-Element
            pbs_project_element = pe_wbs_project_product.pbs_project_elements.build(:name => "Root Element - #{@project.title} WBS-Product", :is_root => true, :work_element_type_id => default_work_element_type.id, :position => 0)
            pbs_project_element.save
            pe_wbs_project_product.save
          end

          if pe_wbs_project_activity.save
            ##New Root Wbs-Project-Element
            wbs_project_element = pe_wbs_project_activity.wbs_project_elements.build(:name => "Root Element - #{@project.title} WBS-Activity", :description => "WBS-Activity Root Element", :author_id => current_user.id)
            wbs_project_element.save
          end

          if current_user.groups.map(&:code_group).include? ("super_admin")
            current_user.project_ids = current_user.project_ids.push(@project.id)
            current_user.save
          end

          redirect_to redirect(edit_project_path(@project)), notice: 'Project was successfully created.'
        else
          flash[:error] = "Error : Project creation failed, #{@project.errors.full_messages.to_sentence}."
          render(:new)
        end
      end

    rescue ActiveRecord::UnknownAttributeError, ActiveRecord::StatementInvalid, ActiveRecord::RecordInvalid => error
      flash[:error] = "Error: Project creation failed, #{@project.errors.full_messages.to_sentence}."
      redirect_to :back
    end

  end

  #Edit a selected project
  def edit
    authorize! :modify_a_project, Project
    set_page_title "Edit project"

    @pe_wbs_project_product = @project.pe_wbs_projects.wbs_product.first
    @pe_wbs_project_activity = @project.pe_wbs_projects.wbs_activity.first

    @wbs_activities = WbsActivity.all

    @wbs_activity_elements = []
    @wbs_activities.each do |wbs_activity|
      @wbs_activity_elements << wbs_activity.wbs_activity_elements.last.root
    end
  end

  def update
    set_page_title "Edit project"

    @pe_wbs_project_product = @project.pe_wbs_projects.wbs_product.first
    @pe_wbs_project_activity = @project.pe_wbs_projects.wbs_activity.first

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

    if @project.update_attributes(params[:project])
      redirect_to redirect(projects_url), notice: 'La mise a jour a été effectué avec succès.'
    else
      render(:edit)
    end
  end
  
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    current_user.delete_recent_project(@project.id)

    session[:current_project_id] = current_user.projects.first

    redirect_to session[:return_to]
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
    redirect_to "/dashboard"
  end

  #Load specific security depending of user selected (last tabs on project editing page)
  def load_security_for_selected_user
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @prj_scrt = ProjectSecurity.find_by_user_id_and_project_id(@user.id, @project.id)
    if @prj_scrt.nil?
      @prj_scrt = ProjectSecurity.create(:user_id => @user.id, :project_id =>  @project.id)
    end

    respond_to do |format|
      format.js { render :partial => "projects/run_estimation" }
    end

  end

  #Load specific security depending of user selected (last tabs on project editing page)
  def load_security_for_selected_group
    @group = Group.find(params[:group_id])
    @project = Project.find(params[:project_id])
    @prj_scrt = ProjectSecurity.find_by_group_id_and_project_id(@group.id, @project.id)
    if @prj_scrt.nil?
      @prj_scrt = ProjectSecurity.create(:group_id => @user.id, :project_id =>  @project.id)
    end

    respond_to do |format|
      format.js { render :partial => "projects/run_estimation" }
    end

  end

  #Updates the security according to the previous users
  def update_project_security_level
    @user = User.find(params[:user_id].to_i)
    @prj_scrt = ProjectSecurity.find_by_user_id_and_project_id(@user.id, current_project.id)
    @prj_scrt.update_attribute("project_security_level_id", params[:project_security_level])

    respond_to do |format|
      format.js { render :partial => "projects/run_estimation" }
    end

  end

    #Updates the security according to the previous users
  def update_project_security_level_group
    @group = Group.find(params[:group_id].to_i)
    @prj_scrt = ProjectSecurity.find_by_group_id_and_project_id(@group.id, current_project.id)
    @prj_scrt.update_attribute("project_security_level_id", params[:project_security_level])

    respond_to do |format|
      format.js { render :partial => "projects/run_estimation" }
    end

  end

  #Allow o add a module to a estimation process
  def add_module

    @array_modules = Pemodule.all
    @project = Project.find(params[:project_id])
    @pemodules ||= Pemodule.all

    #Max pos or 1
    @array_module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1

    #When adding a module in the "timeline", it creates an entry in the table ModuleProject for the current project, at position 2 (the one being reserved for the input module).
    my_module_project = ModuleProject.new(:project_id => @project.id, :pemodule_id => params[:module_selected], :position_y => 1)
    my_module_project.save

    #For each attribute of this new ModuleProject, it copy in the table ModuleAttributeProject, the attributes of modules.
    my_module_project.pemodule.attribute_modules.each do |am|
      @project.pe_wbs_project.pbs_project_elements.each do |c|
        mpa = ModuleProjectAttribute.create(  :attribute_id => am.attribute.id,
                                              :module_project_id => my_module_project.id,
                                              :in_out => am.in_out,
                                              :is_mandatory => am.is_mandatory,
                                              :description => am.description,
                                              :numeric_data_low => am.numeric_data_low,
                                              :numeric_data_most_likely => am.numeric_data_most_likely,
                                              :numeric_data_high => am.numeric_data_high,
                                              :custom_attribute => am.custom_attribute,
                                              :pbs_project_element_id => c.id,
                                              :dimensions => am.dimensions,
                                              :project_value => am.project_value )
      end
    end

    respond_to do |format|
      format.js { render :partial => "pemodules/refresh" }
    end
  end

  #Run estimation process
  def run_estimation
    #@resultat = Array.new
    #
    #@project = current_project
    #@pbs_project_element = current_component
    #@folders = @project.folders.reverse
    #val = 0
    #@array_module_positions = ModuleProject.where(:project_id => @project.id).sort_by{|i| i.position_y}.map(&:position_y).uniq.max || 1
    #
    ##For each level...
    #["low", "most_likely", "high"].each do |level|
    #  #stock input value
    #
    #  input_value  = params["input_#{level}"]
    #
    #  #Execute estimation plan. and stock result
    #  @resultat << @project.run_estimation_plan(1, input_value, {}, @pbs_project_element, current_project) #current_pos, arguments, last_result, others, pbs_project_element, project
    #
    #  @project.module_projects.each do |mp|
    #    mp.module_project_attributes.reject{|i| i.pbs_project_element_id != current_component.id}.each do |mpa|
    #
    #      if mpa.input?
    #
    #        unless input_value[mp.pemodule.alias.to_sym].nil?
    #          val = input_value[mp.pemodule.alias.to_sym][mpa.attribute.alias.to_s]
    #        end
    #
    #        in_result = {}
    #        if mpa.attribute.data_type == "string"
    #          in_result["string_data_#{level}"] = val
    #        else
    #          in_result["numeric_data_#{level}"] = val
    #        end
    #
    #      else
    #        out_result = {}
    #        @resultat.each do |res|
    #          if mpa.attribute.data_type == "date"
    #            out_result["date_data_#{level}"] = res[mp.pemodule.alias.to_sym][mpa.attribute.alias.to_s]
    #          elsif mpa.attribute.data_type == "string"
    #            out_result["string_data_#{level}"] = res[mp.pemodule.alias.to_sym][mpa.attribute.alias.to_s]
    #          else
    #            out_result["numeric_data_#{level}"] = res[mp.pemodule.alias.to_sym][mpa.attribute.alias.to_s]
    #          end
    #        end
    #
    #      mpa.update_attributes(out_result)
    #      mpa.update_attributes(in_result)
    #
    #      end
    #      mpa.update_attribute("pbs_project_element_id", current_component.id)
    #    end
    #  end
    #
    #  #Pour chaque folder
    #  folder_result = {}
    #  @folders.map do |folder| folder.children.map{|j| j.module_project_attributes }.each do |mpa|
    #    %w(low most_likely high).each do |level|
    #      folder_result = { "numeric_data_#{level}" => folder.children.map{|i| i.send("#{mpa.first.attribute.alias}_#{level}") }.flatten.compact.sum}
    #    end
    #    mpa.first.update_attributes(folder_result)
    #  end
    #  end
    #end
    #
    #results = Project::run_estimation_plan
    #
    #respond_to do |format|
    #  format.js { render :partial => "pbs_project_elements/refresh", :object => results }
    #end
  end


  #Method to duplicate project and associated pe_wbs_project
  def duplicate
    begin
      old_prj = Project.find(params[:project_id])

      new_prj = old_prj.amoeba_dup   #amoeba gem is configured in Project class model

      if new_prj.save
        old_prj.save  #Original project copy number will be incremented to 1

        #Managing the compoment tree
        new_prj_components = new_prj.pe_wbs_project.pbs_project_elements

        new_prj_components.each do |new_c|
          unless new_c.is_root?
            new_ancestor_ids_list = []
            new_c.ancestor_ids.each do |ancestor_id|
               ancestor_id = PbsProjectElement.find_by_pe_wbs_project_id_and_copy_id(new_c.pe_wbs_project_id, ancestor_id).id
               new_ancestor_ids_list.push(ancestor_id)
            end
            new_c.ancestry = new_ancestor_ids_list.join('/')
            new_c.save
          end
        end
        #raise "#{RuntimeError}"
      end

      #old_prj.module_projects.each do |mp|
      #  new_mp = mp.dup
      #  new_mp.project_id = new_prj.id
      #  new_mp.save
      #end

      flash[:success] = "Project was successfully duplicated"
      redirect_to "/projects" and return
    rescue
      flash["Error"] = "Duplication failed: Error happened on Project duplication"
      redirect_to "/projects"
    end
  end


  def commit
    project = Project.find(params[:project_id])
    project.commit!
    redirect_to "/projects"
  end

  def activate
    u = current_user
    u.add_recent_project(params[:project_id])
    session[:current_project_id] = params[:project_id]
    redirect_to "/projects"
  end

  def find_use
    @project = Project.find(params[:project_id])
    @related_projects = Project.find(params[:project_id])
    respond_to do |format|
      format.js { render :partial => "projects/find_use" }
    end
  end

  def projects_global_params
    set_page_title "Project global parameters"
  end

  def project_record_number
    @projects = Project.page(params[:page]).per_page(params[:nb].to_i || 1)
    render :partial => "project_record_number"
  end

  def sort_column                                                                                                                    t
    Project.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def default_work_element_type
    wet = WorkElementType.find_by_alias("folder")
    return wet
  end

  def add_wbs_activity_to_project
    @project = Project.find(params[:project_id])
    pe_wbs_project_activity = @project.pe_wbs_projects.wbs_activity.first

    selected_wbs_activity_elt = WbsActivityElement.find(params[:selected_wbs_activity_elt_id])
    wbs_project_element = WbsProjectElement.new(:pe_wbs_project_id => pe_wbs_project_activity.id, :wbs_activity_element_id => selected_wbs_activity_elt.id,
                                                :wbs_activity_id => selected_wbs_activity_elt.wbs_activity_id, :name => selected_wbs_activity_elt.name,
                                                :description => selected_wbs_activity_elt.description, :ancestry => pe_wbs_project_activity.wbs_project_elements.last.root,
                                                :author_id => current_user.id, :copy_number => 0)

    #@pe_wbs_project_activity = @project.pe_wbs_projects.wbs_activity.first
    #@wbs_activities = WbsActivity.all
    #
    #@wbs_activity_elements = []
    #@wbs_activities.each do |wbs_activity|
    #  @wbs_activity_elements << wbs_activity.wbs_activity_elements.last.root
    #end

    #render :partial => "add_wbs_project_element"
  end

end
