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

class PlatformCategoriesController < ApplicationController
  # GET /platform_categories
  # GET /platform_categories.json
  def index
    @platform_categories = PlatformCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @platform_categories }
    end
  end

  # GET /platform_categories/1
  # GET /platform_categories/1.json
  def show
    @platform_category = PlatformCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @platform_category }
    end
  end

  # GET /platform_categories/new
  # GET /platform_categories/new.json
  def new
    @platform_category = PlatformCategory.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @platform_category }
    end
  end

  # GET /platform_categories/1/edit
  def edit
    @platform_category = PlatformCategory.find(params[:id])
  end

  # POST /platform_categories
  # POST /platform_categories.json
  def create
    @platform_category = PlatformCategory.new(params[:platform_category])

    respond_to do |format|
      if @platform_category.save
        format.html { redirect_to "/projects_global_params", notice: 'Platform category was successfully created.' }
        format.json { render json: @platform_category, status: :created, location: @platform_category }
      else
        format.html { render action: "new" }
        format.json { render json: @platform_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /platform_categories/1
  # PUT /platform_categories/1.json
  def update
    @platform_category = PlatformCategory.find(params[:id])

    respond_to do |format|
      if @platform_category.update_attributes(params[:platform_category])
        format.html { redirect_to "/projects_global_params", notice: 'Platform category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @platform_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /platform_categories/1
  # DELETE /platform_categories/1.json
  def destroy
    @platform_category = PlatformCategory.find(params[:id])
    @platform_category.destroy

    respond_to do |format|
      format.html { redirect_to platform_categories_url }
      format.json { head :ok }
    end
  end
end
