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

class ProjectAreasController < ApplicationController

  def new
    set_page_title "Project Area"
    @project_area = ProjectArea.new
    @activity_categories = ActivityCategory.all
    @acquisition_catageories = AcquisitionCategory.all
    @labor_catageories = LaborCategory.all
    @platform_categories = PlatformCategory.all
    @project_categories = ProjectCategory.all
  end

  # GET /project_areas/1/edit
  def edit
    set_page_title "Project Area"
    @project_area = ProjectArea.find(params[:id])
    @activity_categories = ActivityCategory.all
    @acquisition_catageories = AcquisitionCategory.all
    @labor_catageories = LaborCategory.all
    @platform_categories = PlatformCategory.all
    @project_categories = ProjectCategory.all
  end


  def create
    @project_area = ProjectArea.new(params[:project_area])

    if @project_area.save
      flash[:notice] = "Project area was successfully created."
      redirect_to redirect("/projects_global_params#tabs-1")
    else
       render action: "new"
    end
  end

  def update
    @project_area = ProjectArea.find(params[:id])
    
    if @project_area.update_attributes(params[:project_area])
      flash[:notice] = "Project area was successfully updated."
      redirect_to redirect("/projects_global_params#tabs-1")
    else
       render action: "new"
    end
  end

  def destroy
    @project_area = ProjectArea.find(params[:id])
    @project_area.destroy
    flash[:notice] = "Project area was successfully deleted."
    redirect_to "/projects_global_params#tabs-1"
  end
end
