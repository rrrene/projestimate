#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2013 Spirula (http://www.spirula.fr)
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
#
class AttributeCategoriesController < ApplicationController
  include DataValidationHelper #Module for master data changes validation
  before_filter :get_record_statuses
                               # GET /attribute_categories
                               # GET /attribute_categories.json
  def index
    authorize! :manage_attributes, AttributeCategory
    set_page_title "Attributes Categories"
    @attribute_categories = AttributeCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @attribute_categories }
    end
  end

  # GET /attribute_categories/1
  # GET /attribute_categories/1.json
  def show
    authorize! :manage_attributes, AttributeCategory
    set_page_title "Attributes Categories"
    @attribute_category = AttributeCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @attribute_category }
    end
  end

  # GET /attribute_categories/new
  # GET /attribute_categories/new.json
  def new
    authorize! :manage_attributes, AttributeCategory
    set_page_title "Attributes Categories"
    @attribute_category = AttributeCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @attribute_category }
    end
  end

  # GET /attribute_categories/1/edit
  def edit
    authorize! :manage_attributes, AttributeCategory
    set_page_title "Attributes Categories"
    @attribute_category = AttributeCategory.find(params[:id])
  end

  # POST /attribute_categories
  # POST /attribute_categories.json
  def create
    authorize! :manage_attributes, AttributeCategory
    set_page_title "Attributes Categories"
    @attribute_category = AttributeCategory.new(params[:attribute_category])

    respond_to do |format|
      if @attribute_category.save
        format.html { redirect_to attribute_categories_path, notice: 'Attribute category was successfully created.' }
        format.json { render json: @attribute_category, status: :created, location: @attribute_category }
      else
        format.html { render action: "new" }
        format.json { render json: @attribute_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /attribute_categories/1
  # PUT /attribute_categories/1.json
  def update
    @attribute_category = AttributeCategory.find(params[:id])

    respond_to do |format|
      if @attribute_category.update_attributes(params[:attribute_category])
        format.html { redirect_to attribute_categories_path, notice: 'Attribute category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @attribute_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attribute_categories/1
  # DELETE /attribute_categories/1.json
  def destroy
    @attribute_category = AttributeCategory.find(params[:id])
    @attribute_category.destroy

    respond_to do |format|
      format.html { redirect_to attribute_categories_url }
      format.json { head :no_content }
    end
  end
end
