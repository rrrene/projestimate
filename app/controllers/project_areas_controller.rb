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
  # GET /project_areas
  # GET /project_areas.json
  def index
    set_page_title "Project Area"
    @project_areas = ProjectArea.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_areas }
    end
  end

  # GET /project_areas/1
  # GET /project_areas/1.json
  def show
    set_page_title "Project Area"
    @project_area = ProjectArea.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project_area }
    end
  end

  # GET /project_areas/new
  # GET /project_areas/new.json
  def new
    set_page_title "Project Area"
    @project_area = ProjectArea.new
    @activity_categories = ActivityCategory.all
    @acquisition_catageories = AcquisitionCategory.all
    @labor_catageories = LaborCategory.all
    @platform_categories = PlatformCategory.all
    @project_categories = ProjectCategory.all

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @project_area }
    end
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

  # POST /project_areas
  # POST /project_areas.json
  def create
    @project_area = ProjectArea.new(params[:project_area])

    respond_to do |format|
      if @project_area.save
        format.html
        format.json { render json: @project_area, status: :created, location: @project_area }
      else
        format.html { render action: "new" }
        format.json { render json: @project_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /project_areas/1
  # PUT /project_areas/1.json
  def update
    @project_area = ProjectArea.find(params[:id])
    
    respond_to do |format|
      if @project_area.update_attributes(params[:project_area])
        format.html { redirect_to "/projects_global_params", notice: 'Project area was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_areas/1
  # DELETE /project_areas/1.json
  def destroy
    @project_area = ProjectArea.find(params[:id])
    @project_area.destroy

    respond_to do |format|
      format.html { redirect_to project_areas_url }
      format.json { head :ok }
    end
  end
end
