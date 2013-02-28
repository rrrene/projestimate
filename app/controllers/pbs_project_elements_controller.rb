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

class PbsProjectElementsController < ApplicationController


  def edit
    @pbs_project_element = PbsProjectElement.find(params[:id])
    set_page_title("Editing #{@pbs_project_element.name}")

    @project = Project.find(params[:project_id])

    #Select folders which could be a parent of a pbs_project_element
    #a pbs_project_element cannot be its own parent
    @folder_components = @project.pe_wbs_projects.wbs_product.first.pbs_project_elements.select{ |i| i.work_element_type.alias == "folder" }
    @folder_components
  end

  def update
    @pbs_project_element = PbsProjectElement.find(params[:id])

    if @pbs_project_element.update_attributes(params[:pbs_project_element])
      # Another update attributes...
      @pbs_project_element.update_attribute :parent, PbsProjectElement.find(params[:pbs_project_element][:ancestry])
      redirect_to redirect("/dashboard")
    else
      flash[:error] = "Please verify pbs_project_elements value"
      redirect_to redirect("/dashboard")
    end
  end

  def destroy
    #set somes variables
    pbs_project_element = PbsProjectElement.find(params[:id])
    @project = pbs_project_element.pe_wbs_project.project
    @pbs_project_element = @project.root_component
    @module_projects = @project.module_projects

    pbs_project_element.module_project_attributes.each do |mpa|
      mpa.destroy
    end

    #Destroy the selected pbs_project_element
    pbs_project_element.destroy

    #Reload position
    @project.pe_wbs_projects.wbs_product.first.pbs_project_elements.each_with_index do |c,i|
      c.position = i
      c.save
    end

    render :partial => "pbs_project_elements/refresh"
  end

  #Select the current pbs_project_element and refresh the partial
  def selected_pbs_project_element
    session[:pbs_project_element_id] = params[:id]

    @user = current_user
    @project = current_project
    @module_projects = @project.module_projects
    @pbs_project_element = current_component
    @array_module_positions = ModuleProject.where(:project_id => @project.id).sort_by{|i| i.position_y}.map(&:position_y).uniq.max || 1
    @results = nil

    render :partial => "pbs_project_elements/refresh"
  end

  #Create a new pbs_project_element and refresh the partials
  def new
    @pe_wbs_project = PeWbsProject.find(params[:pe_wbs_project_id])
    @project = @pe_wbs_project.project
    @array_module_positions = ModuleProject.where(:project_id => @project.id).sort_by{|i| i.position_y}.map(&:position_y).uniq.max || 1
    @pbs_project_element = PbsProjectElement.new
    @pbs_project_element.pe_wbs_project_id = params[:pe_wbs_project_id]
    @pbs_project_element.parent_id = params[:comp_parent_id]

    if params[:type_component] == "folder"
      @pbs_project_element.name = "New folder"
      @pbs_project_element.work_element_type_id = WorkElementType.find_by_alias("folder").id
    elsif params[:type_component] == "link"
      @pbs_project_element.name = "New link"
      @pbs_project_element.work_element_type_id = WorkElementType.find_by_alias("link").id
    else
      @pbs_project_element.name = "New pbs_project_element"
      @pbs_project_element.work_element_type_id = WorkElementType.find_by_alias("undefined").id
    end
    @pbs_project_element.position = @pe_wbs_project.pbs_project_elements.map(&:position).max + 1
    @pbs_project_element.save

    #Set current pbs_project_element
    session[:pbs_project_element_id] = @pbs_project_element.id

    @user = current_user

    @project.module_projects.each do |mp|
      mp.module_project_attributes.reject{|i| i.pbs_project_element_id != @project.root_component.id }.each do |mpa|
        new_mpa = mpa.dup
        new_mpa.save
        mpa.update_attribute("pbs_project_element_id", @pbs_project_element.id)
      end
    end

    @module_projects = current_project.module_projects

    render :partial => "pbs_project_elements/refresh_tree"
  end

  #Pushed up the pbs_project_element
  def up
    @project = Project.find(params[:project_id])

    component_a = PbsProjectElement.find(params[:pbs_project_element_id])
    unless component_a.position == 1
      component_b = PbsProjectElement.find_by_position_and_pe_wbs_project_id(component_a.position - 1, params[:pe_wbs_project_id])
      component_a.update_attribute("position", component_a.position - 1)
      component_b.update_attribute("position", component_b.position + 1)
    end

    @user = current_user

    render :partial => "pbs_project_elements/refresh", :object => @project
  end

  #Pushed down the pbs_project_element
  def down
    @project = Project.find(params[:project_id])

    component_a = PbsProjectElement.find(params[:pbs_project_element_id])
    unless component_a.position == @project.pe_wbs_project.pbs_project_elements.map(&:position).max
      component_b = PbsProjectElement.find_by_position(component_a.position + 1)
      component_a.update_attribute("position", component_a.position + 1)
      component_b.update_attribute("position", component_b.position - 1)
    end

    @user = current_user

    render :partial => "pbs_project_elements/refresh", :object => @project
  end
end
