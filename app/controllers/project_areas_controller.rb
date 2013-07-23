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

class ProjectAreasController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses
  before_filter :get_associations_records, :only => [:new, :edit, :create, :update]

  def get_associations_records
    @activity_categories = ActivityCategory.all
    @acquisition_categories = AcquisitionCategory.all
    @labor_categories = LaborCategory.all
    @platform_categories = PlatformCategory.all
    @project_categories = ProjectCategory.all
  end

  def new
    set_page_title 'Project Area'
    @project_area = ProjectArea.new
  end

  def edit
    set_page_title 'Project Area'
    @project_area = ProjectArea.find(params[:id])

    unless @project_area.child_reference.nil?
      if @project_area.child_reference.is_proposed_or_custom?
        flash[:warning] = I18n.t (:warning_project_area_cant_be_edit)
        redirect_to redirect_save(projects_global_params_path(:anchor => 'tabs-1'))
      end
    end
  end


  def create
    @project_area = ProjectArea.new(params[:project_area])

    if @project_area.save
      flash[:notice] = I18n.t (:notice_project_area_successful_created)
      redirect_to redirect_save(projects_global_params_path(:anchor => 'tabs-1'), new_project_area_path())
    else
       render action: 'new'
    end
  end

  def update
    @project_area = nil
    current_project_area = ProjectArea.find(params[:id])
    if current_project_area.is_defined?
      @project_area = current_project_area.amoeba_dup
      @project_area.owner_id = current_user.id
    else
      @project_area = current_project_area
    end

    if @project_area.update_attributes(params[:project_area])
      flash[:notice] = I18n.t (:notice_project_area_successful_updated)
      redirect_to redirect_save(projects_global_params_path(:anchor => 'tabs-1'), edit_project_area_path(@project_area))
    else
      render action: 'edit'
    end
  end

  def destroy
    @project_area = ProjectArea.find(params[:id])
    if @project_area.is_defined? || @project_area.is_custom?
      #logical deletion: delete don't have to suppress records anymore if record status is defined
      @project_area.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
    else
      @project_area.destroy
    end

    flash[:notice] = I18n.t (:notice_project_area_successful_deleted)
    redirect_to projects_global_params_path(:anchor => 'tabs-1')
  end
end
