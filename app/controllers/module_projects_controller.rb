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

class ModuleProjectsController < ApplicationController


  def pbs_element_matrix
    set_page_title 'Associate PBS-element'
    @project = Project.find(params[:project_id])
    @module_projects = @project.module_projects

    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
    @module_positions_x = @project.module_projects.order(:position_x).all.map(&:position_x).max
  end

  def associate
    @project = Project.find(params[:project_id])
    @module_projects = @project.module_projects
    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
    @module_positions_x = @project.module_projects.order(:position_x).all.map(&:position_x).max

    @module_projects.each do |mp|
      mp.update_attribute('pbs_project_element_ids', params[:pbs_project_elements][mp.id.to_s])
    end

    redirect_to redirect(edit_project_path(@project, :anchor => 'tabs-4'))
  end

  def index
    @module_projects = ModuleProject.all
  end

  def edit
    @module_project = ModuleProject.find(params[:id])
    @project = @module_project.project
    @module_projects = @project.module_projects
    @references_values = ReferenceValue.all

    # Get the max X and Y positions of modules
    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
    @module_positions_x = @project.module_projects.order(:position_x).all.map(&:position_x).max

    set_page_title "Editing #{@module_project.pemodule.title}"
  end

  def create
    @module_project = ModuleProject.new(params[:module_project])

    if @module_project.save
      redirect_to redirect(@module_project), notice: "#{I18n.t (:notice_module_project_successful_created)}"
    else
      render action: 'new'
    end
  end

  def update
    @module_project = ModuleProject.find(params[:id])
    @project = @module_project.project

    @module_project.estimation_values.each_with_index do |est_val, j|
      corresponding_am = AttributeModule.where("pemodule_id =? and pe_attribute_id = ?", @module_project.pemodule.id, est_val.pe_attribute.id).first
      unless corresponding_am.is_mandatory
        est_val.update_attribute('is_mandatory', params["is_mandatory_#{est_val.id}_#{est_val.in_out}"])
      end
      est_val.update_attribute('description', params["description_#{est_val.id}_#{est_val.in_out}"])
    end

    # Get the project's max X and Y positions of modules
    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
    @module_positions_x = @project.module_projects.order(:position_x).all.map(&:position_x).max

    redirect_to redirect(edit_module_project_path(@module_project)), notice: "#{I18n.t (:notice_module_project_successful_updated)}"
  end

  def module_projects_matrix
    @project = Project.find(params[:project_id])
    @module_projects = @project.module_projects
    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
    @module_positions_x = @project.module_projects.order(:position_x).all.map(&:position_x).max
  end

  def associate_modules_projects
    @project = Project.find(params[:project_id])
    @module_projects = @project.module_projects

    @module_projects.each do |mp|
      mp.update_attribute('associated_module_project_ids', params[:module_projects][mp.id.to_s])
    end
    redirect_to redirect(edit_project_path(@project.id, :anchor => "tabs-4")), notice: "#{I18n.t (:notice_module_project_successful_updated)}"
  end


  def destroy
    @module_project = ModuleProject.find(params[:id])
    @project = @module_project.project

    #re-set positions
    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1

    #...finally, destroy object module_project
    @module_project.destroy

    redirect_to edit_project_path(@project.id, :anchor => 'tabs-4')
  end

  def associate_module_project_to_ratios
    @module_project = ModuleProject.find(params[:module_project_id])
    @project = Project.find(params[:project_id])
    @module_projects = @project.module_projects
    @references_values = ReferenceValue.all

    @module_projects.each do |mp|
      mp.update_attribute(:reference_value_id, params["module_projects_#{mp.id.to_s}"])
    end

    if params[:commit] == I18n.t('apply')
      flash[:notice] = I18n.t (:notice_module_project_successful_updated)
      redirect_to redirect(edit_module_project_path(@module_project.id, :anchor => 'tabs-3'))  #redirect_to :back
    else
      redirect_to redirect(edit_project_path(@project.id, :anchor => 'tabs-4')), notice: "#{I18n.t (:notice_module_project_successful_updated)}"
    end
  end

end
