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
    respond_to do |format|
      format.html
      format.json { render json: ProjectsDatatable.new(view_context) }
    end
  end

  def new
    set_page_title "New project"
  end

  #Create a new project
  def create
    set_page_title "Create project"

    @project = Project.new(params[:project])

    if @project.save
      if current_user.groups.map(&:code_group).include? ("super_admin")
        current_user.project_ids = current_user.project_ids.push(@project.id)
        current_user.save
      end

    #New default wbs
    wbs = Wbs.new(:project => @project)
    wbs.save

    #New root component
    component = Component.new(:is_root => true, :wbs_id => wbs.id, :work_element_type_id => default_work_element_type.id, :position => 0, :name => "Root folder")
    component.save

      redirect_to redirect(edit_project_path(@project)), notice: 'Project was successfully created.'
    else
      render(:new)
    end
  end

  #Edit a selected project
  def edit
    authorize! :modify_a_project, Project
    set_page_title "Edit project"
  end

  def update
    set_page_title "Edit project"

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

    #Max pos or 1
    @array_module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1

    #When adding a module in the "timeline", it creates an entry in the table ModuleProject for the current project, at position 2 (the one being reserved for the input module).
    my_module_project = ModuleProject.new(:project_id => @project.id, :pemodule_id => params[:module_selected], :position_y => 1)
    my_module_project.save

    #For each attribute of this new ModuleProject, it copy in the table ModuleAttributeProject, the attributes of modules.
    my_module_project.pemodule.attribute_modules.each do |am|
      @project.wbs.components.each do |c|
        mpa = ModuleProjectAttribute.new( :attribute_id => am.attribute.id,
                                          :module_project_id => my_module_project.id,
                                          :in_out => am.in_out,
                                          :is_mandatory => am.is_mandatory,
                                          :description => am.description,
                                          :numeric_data_low => am.numeric_data_low,
                                          :numeric_data_most_likely => am.numeric_data_most_likely,
                                          :numeric_data_high => am.numeric_data_high,
                                          :custom_attribute => am.custom_attribute,
                                          :component_id => c.id,
                                          :dimensions => am.dimensions,
                                          :project_value => am.project_value )
        mpa.save
      end
    end

    respond_to do |format|
      format.js { render :partial => "pemodules/refresh" }
    end
  end

  #Run estimation process
  def run_estimation
    @resultat = Array.new

    #TODO:Refactoring this block
    custom_params = HashWithIndifferentAccess.new(params)
    custom_params.delete("utf8")
    custom_params.delete("commit")
    custom_params.delete("action")
    custom_params.delete("controller")
    custom_params.delete("component_id")

    @project = current_project
    @component = current_component
    @folders = @project.folders.reverse
    @val = 0
    @array_module_positions = ModuleProject.where(:project_id => @project.id).sort_by{|i| i.position_y}.map(&:position_y).uniq.max || 1

    #For each level...
    ["low", "most_likely", "high"].each do |level|
      #stock input value
      input_value = custom_params["input_#{level}"]

      #Execute estimation plan. and stock result
      @resultat << @project.run_estimation_plan(1, custom_params["input_" + level], {}, @component, current_project) #current_pos, arguments, last_result, others, component, project

      @project.module_projects.each do |mp|
        mp.module_project_attributes.reject{|i| i.component_id != current_component.id}.each do |mpa|

          if mpa.input?
            unless input_value[mp.pemodule.alias.to_sym].nil?
              @val = input_value[mp.pemodule.alias.to_sym][mpa.attribute.alias.to_s]
            end
            if mpa.attribute.data_type == "string"
              mpa.update_attribute("string_data_#{level}", @val)
            else
              #if mpa.attribute.is_validate(@val)
                notice = ""
                mpa.update_attribute("numeric_data_#{level}", @val)
              #end
            end
          else
            @resultat.each do |res|
              result = res[mp.pemodule.alias.to_sym][mpa.attribute.alias.to_s]
              if mpa.attribute.data_type == "date"
                mpa.update_attribute("date_data_#{level}", result)
              elsif mpa.attribute.data_type == "string"
                mpa.update_attribute("string_data_#{level}", result)
              else
                mpa.update_attribute("numeric_data_#{level}", result)
              end
            end
          end
          mpa.update_attribute("component_id", current_component.id)
        end
      end

      #Pour chaque folder
      @folders.each do |folder|
        folder.children.each do |child|
          folder.module_project_attributes.each do |mpa|
            %w(low most_likely high).each do |level|
              mpa.update_attribute("numeric_data_#{level}", folder.children.map{|i| i.send("#{mpa.attribute.alias}_#{level}") }.flatten.compact.sum )
            end
          end
        end
      end
    end

    respond_to do |format|
      format.js { render :partial => "components/refresh" }
    end
  end

  def duplicate
    old_prj = Project.find(params[:project_id])
    new_prj = old_prj.dup

    new_prj.group_ids = old_prj.groups.map(&:id)
    new_prj.user_ids = old_prj.users.map(&:id)
    new_prj.title = "Copy of #{ old_prj.title }"
    new_prj.save

    old_prj.module_projects.each do |mp|
      new_mp = mp.dup
      new_mp.project_id = new_prj.id
      new_mp.save
    end

    new_wbs = old_prj.wbs.dup
    new_wbs.save

    old_prj.wbs.components.each do |c|
      if c.is_root?
        new_c = c.dup
        new_c.wbs_id = new_prj.wbs.id
        new_c.ancestry = new_prj.root_component.id
        new_c.save
      #else
      #  new_c = c.dup
      #  new_c.wbs_id = new_wbs.id
      #  new_c.ancestry = new_prj.root_component.id
      #  new_c.save
      end
    end

    redirect_to "/projects"
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

end
