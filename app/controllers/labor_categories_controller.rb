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

class LaborCategoriesController < ApplicationController

  def index
    set_page_title "Labors Categories"
    authorize! :manage_labor_categories, LaborCategory
    @labor_categories = LaborCategory.all
  end

  def new
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.new

    respond_to do |format|
      format.html # _new.html.erb
    end
  end

  def edit
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.find(params[:id])
  end

  def create
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.new(params[:labor_category])

    respond_to do |format|
      if @labor_category.save
        format.html { redirect_to @labor_category, notice: 'Labor category was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.find(params[:id])

    respond_to do |format|
      if @labor_category.update_attributes(params[:labor_category])
        format.html { redirect_to @labor_category, notice: 'Labor category was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.find(params[:id])
    @labor_category.destroy

    respond_to do |format|
      format.html { redirect_to labor_categories_url }
    end
  end

end
