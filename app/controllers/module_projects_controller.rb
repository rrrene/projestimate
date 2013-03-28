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

class ModuleProjectsController < ApplicationController


  def pbs_element_matrix
    set_page_title "Associate PBS-element"
    @project = Project.find(params[:project_id])
    @module_projects = @project.module_projects
  end

  def associate
    @project = Project.find(params[:project_id])
    @module_projects = @project.module_projects

    @module_projects.each do |mp|
      mp.update_attribute("pbs_project_element_ids", params[:pbs_project_elements][mp.id.to_s])
    end

    redirect_to redirect(pbs_element_matrix_path(@project.id))

  end

  def index
    @module_projects = ModuleProject.all
  end

  def edit
    @module_project = ModuleProject.find(params[:id])
    @project = @module_project.project
    @module_projects = @project.module_projects
    @references_values = ReferenceValue.all

    set_page_title "Editing #{@module_project.pemodule.title}"
  end

  def create
    @module_project = ModuleProject.new(params[:module_project])

    if @module_project.save
      redirect_to redirect(@module_project), notice: 'Module project was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @module_project = ModuleProject.find(params[:id])
    @project = @module_project.project
    maps = params["module_project_attributes"]

    unless maps.nil?
      maps.keys.each do |k|
        a = ModuleProjectAttribute.find(k)
        ModuleProjectAttribute.where(:attribute_id => a.attribute_id, :module_project_id => @module_project.id).each do |mpa|
          mpa.links << ModuleProjectAttribute.find(maps[k].keys.first)
          mpa.save
        end
      end
    end

    @project.pe_wbs_projects.wbs_product.first.pbs_project_elements.each do |c|
      @module_project.module_project_attributes.select{|i| i.pbs_project_element_id == c.id }.each_with_index do |mpa, j|
        if mpa.custom_attribute == "user"
          mpa.update_attribute("is_mandatory", params[:is_mandatory][j])
          mpa.update_attribute("in_out", params[:in_out][j])
          mpa.update_attribute("description", params[:description][j])
        end
      end
    end

    @module_projects.each do |mp|
      mp.update_attribute("associated_module_project_ids", params[:module_projects][mp.id.to_s])
    end

    redirect_to redirect(edit_module_project_path(@module_project)), notice: 'Module project was successfully updated.'
  end

  def module_projects_matrix
    @project = Project.find(params[:project_id])
    @module_projects = @project.module_projects
  end

  def associate_modules_projects
    @project = Project.find(params[:project_id])
    @module_projects = @project.module_projects
    @module_projects.each do |mp|
      mp.update_attribute("associated_module_project_ids", params[:module_projects][mp.id.to_s])
    end
    redirect_to redirect(edit_project_path(@project.id)), notice: 'Module project was successfully updated.'
  end

  def destroy
    @module_project = ModuleProject.find(params[:id])
    @project = @module_project.project

    #re-set positions
    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1

    #...finally, destroy object module_project
    @module_project.destroy

    redirect_to edit_project_path(@project.id, :anchor => "tabs-4")
  end

  def associate_module_project_to_ratios
    @project = Project.find(params[:project_id])
    @module_projects = @project.module_projects
    @references_values = ReferenceValue.all

    @module_projects.each do |mp|
      mp.update_attribute(:reference_value_id, params["module_projects_#{mp.id.to_s}"])
    end
    if params[:commit] == "Save"
      redirect_to redirect(edit_project_path(@project.id)), notice: 'Module project was successfully updated.'
    elsif params[:commit] == "Apply"
      flash[:notice] = 'Module project was successfully updated.'
      redirect_to :back
    end

  end

end
