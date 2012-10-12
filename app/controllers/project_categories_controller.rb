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

class ProjectCategoriesController < ApplicationController
  # GET /project_categories
  # GET /project_categories.json
  def index
    @project_categories = ProjectCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_categories }
    end
  end

  # GET /project_categories/1
  # GET /project_categories/1.json
  def show
    @project_category = ProjectCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project_category }
    end
  end

  # GET /project_categories/new
  # GET /project_categories/new.json
  def new
    @project_category = ProjectCategory.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @project_category }
    end
  end

  # GET /project_categories/1/edit
  def edit
    @project_category = ProjectCategory.find(params[:id])
  end

  # POST /project_categories
  # POST /project_categories.json
  def create
    @project_category = ProjectCategory.new(params[:project_category])

    respond_to do |format|
      if @project_category.save
        format.html { redirect_to "/projects_global_params", notice: 'Project category was successfully created.' }
        format.json { render json: @project_category, status: :created, location: @project_category }
      else
        format.html { render action: "new" }
        format.json { render json: @project_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /project_categories/1
  # PUT /project_categories/1.json
  def update
    @project_category = ProjectCategory.find(params[:id])

    respond_to do |format|
      if @project_category.update_attributes(params[:project_category])
        format.html { redirect_to @project_category, notice: 'Project category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_categories/1
  # DELETE /project_categories/1.json
  def destroy
    @project_category = ProjectCategory.find(params[:id])
    @project_category.destroy

    respond_to do |format|
      format.html { redirect_to project_categories_url }
      format.json { head :ok }
    end
  end
end
