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

class WbsProjectElementsController < ApplicationController
  load_and_authorize_resource
  helper_method :disabled_if_from_library

  def disabled_if_from_library
    if params[:action] == 'new'
      false
    else
      if @wbs_project_element.wbs_activity.nil?
        false
      else
        true
      end
    end
  end


  # GET /wbs_project_elements
  # GET /wbs_project_elements.json
  def index
    @wbs_project_elements = WbsProjectElement.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wbs_project_elements }
    end
  end

  # GET /wbs_project_elements/1
  # GET /wbs_project_elements/1.json
  def show
    @wbs_project_element = WbsProjectElement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wbs_project_element }
    end
  end

  # GET /wbs_project_elements/new
  # GET /wbs_project_elements/new.json
  def new
    @wbs_project_element = WbsProjectElement.new

    @selected_parent ||= WbsProjectElement.find_by_id(params[:selected_parent_id])
    @project = Project.find(params[:project_id])
    @pe_wbs_project_activity = @project.pe_wbs_projects.activities_wbs.first
    @pe_wbs_project_product = @project.pe_wbs_projects.products_wbs.first
    @potential_parents = @pe_wbs_project_activity.wbs_project_elements.all.reject{|elt| elt.can_get_new_child == false}

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wbs_project_element }
    end
  end


  # GET /wbs_project_elements/1/edit
  def edit
    @wbs_project_element = WbsProjectElement.find(params[:id])

    @project = Project.find(params[:project_id])
    @pe_wbs_project_activity = @project.pe_wbs_projects.activities_wbs.first
    @pe_wbs_project_product = @project.pe_wbs_projects.products_wbs.first


    if @wbs_project_element.is_root
      @selected_parent = nil
      @potential_parents = nil
    else
      @selected_parent = @wbs_project_element.parent
      @potential_parents = @pe_wbs_project_activity.wbs_project_elements.all.reject{|elt| elt.can_get_new_child == false}
    end
  end

  # POST /wbs_project_elements
  # POST /wbs_project_elements.json
  def create
    @wbs_project_element = WbsProjectElement.new(params[:wbs_project_element])
    @wbs_project_element.author_id = current_user.id

    @project = Project.find(params[:project_id])
    @selected_parent ||= WbsProjectElement.find_by_id(params[:wbs_project_element][:parent_id])

    @pe_wbs_project_activity = @project.pe_wbs_projects.activities_wbs.first
    @pe_wbs_project_product =  @project.pe_wbs_projects.products_wbs.first
    @potential_parents = @pe_wbs_project_activity.wbs_project_elements.all.reject{|elt| elt.can_get_new_child == false}

    if @wbs_project_element.save
      @wbs_project_element.update_can_get_new_child
     redirect_to redirect(edit_project_path(@project, :anchor => 'tabs-3')), notice: "#{I18n.t (:notice_wbs_project_element_successful_created)}"
    else
      render action: 'new'
    end
  end

  # PUT /wbs_project_elements/1
  # PUT /wbs_project_elements/1.json
  def update
    @wbs_project_element = WbsProjectElement.find(params[:id])
    @project = Project.find(params[:project_id])

    @selected_parent ||= WbsProjectElement.find_by_id(params[:wbs_project_element][:parent_id])
    @pe_wbs_project_activity = @project.pe_wbs_projects.activities_wbs.first
    @pe_wbs_project_product = @project.pe_wbs_projects.products_wbs.first
    @potential_parents = @pe_wbs_project_activity.wbs_project_elements.all.reject{|elt| elt.can_get_new_child == false}

    respond_to do |format|
      if @wbs_project_element.update_attributes(params[:wbs_project_element])
        format.html { redirect_to redirect(edit_project_path(@project, :anchor => 'tabs-3')), notice: "#{I18n.t (:notice_wbs_project_element_successful_updated)}"}
        format.json { head :no_content }
      else
        flash[:error] = @wbs_project_element.errors.full_messages.to_sentence
        format.html { render action: 'edit' }
        format.json { render json: @wbs_project_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wbs_project_elements/1
  # DELETE /wbs_project_elements/1.json
  def destroy
    @wbs_project_element = WbsProjectElement.find(params[:id])
    @project = Project.find(params[:project_id])

    if @wbs_project_element.destroy
      @project.included_wbs_activities.delete(@wbs_project_element.wbs_activity_id)
      @project.save
    end

    respond_to do |format|
      #format.html { redirect_to edit_project_path(@project), :notice => 'Wbs-Project-Element was successfully deleted.' }
      format.html { redirect_to edit_project_path(@project, :anchor => 'tabs-3'), :notice => "#{I18n.t (:notice_wbs_project_element_successful_deleted)}" }

      format.json { head :no_content }
    end
  end

  #Select the current pbs_project_element and refresh the partial
  def selected_wbs_project_element
    session[:wbs_project_element_id] = params[:id]

    @user = current_user
    @project = current_project
    @wbs_project_element = current_wbs_project_element
    @module_positions = ModuleProject.where(:project_id => @project.id).sort_by{|i| i.position_y}.map(&:position_y).uniq.max || 1

    render :partial => 'wbs_project_elements/refresh'
  end

  # Allow user to switch from on ratio table to another
  def change_wbs_project_ratio
    @project = Project.find(params[:project_id])
    @wbs_project_element = WbsProjectElement.find(params[:wbs_project_id])
    @possible_wbs_activity_ratios = @wbs_project_element.wbs_activity.wbs_activity_ratios
  end

  def update_wbs_project_ratio_value
    @project = Project.find(params[:project_id])
    @wbs_project_element = WbsProjectElement.find(params[:wbs_project_id])
    @possible_wbs_activity_ratios = @wbs_project_element.wbs_activity.wbs_activity_ratios

    @wbs_project_element.wbs_activity_ratio_id = params[:wbs_activity_ratio_id]
    if @wbs_project_element.save
      flash[:notice] = @wbs_project_element.name+" #{I18n.t (:notice_ratio_successful_changed)}"
    else
      flash[:error] = I18n.t (:error_wbs_project_element_ratio_failed_update)
    end

    respond_to do |format|
      format.html { redirect_to edit_project_path(@project, :anchor => 'tabs-3') }

      format.js { redirect_to edit_project_path(@project, :anchor => 'tabs-3') }
    end
  end

end
