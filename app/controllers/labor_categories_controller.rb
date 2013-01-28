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
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

  def index
    set_page_title "Labors Categories"
    authorize! :manage_labor_categories, LaborCategory
    @labor_categories = LaborCategory.all
  end

  def new
    set_page_title "Labors Categories"
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.new

    respond_to do |format|
      format.html # _new.html.erb
    end
  end

  def edit
    set_page_title "Labors Categories"
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.find(params[:id])

    unless @labor_category.child_reference.nil?
      if @labor_category.child_reference.is_proposed_or_custom?
        flash[:notice] = "This labor category can not be edited, previous changes have not yet been validated."
        redirect_to redirect(labor_categories_path)
      end
    end
  end

  def create
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.new(params[:labor_category])
    if @labor_category.save
      flash[:notice] = "Labor category was successfully created."
      redirect_to redirect(labor_categories_path)
    else
      render action: "new"
    end
  end

  def update
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = nil
    current_labor_category = LaborCategory.find(params[:id])
    if current_labor_category.is_defined?
      @labor_category = current_labor_category.amoeba_dup
      @labor_category.owner_id = current_user.id
    else
      @labor_category = current_labor_category
    end

    if @labor_category.update_attributes(params[:labor_category])
      flash[:notice] = "Labor category was successfully updated."
      redirect_to redirect(labor_categories_path), :notice => "Labor category was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.find(params[:id])
    if @labor_category.is_defined? || @labor_category.is_custom?
      #logical deletion: delete don't have to suppress records anymore
      @labor_category.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
    else
      @labor_category.destroy
    end

    flash[:notice] = "Labor category was successfully deleted."
    redirect_to labor_categories_path
  end

end
