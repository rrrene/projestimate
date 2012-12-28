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

class ActivityCategoriesController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

  def index
    @activity_categories = ActivityCategory.all
  end

  def new
    authorize! :manage_activity_categories, ActivityCategory
    @activity_category = ActivityCategory.new
  end

  def edit
    authorize! :manage_activity_categories, ActivityCategory
    @activity_category = ActivityCategory.find(params[:id])
  end

  def create
    authorize! :manage_activity_categories, ActivityCategory
    @activity_category = ActivityCategory.new(params[:activity_category])
    @activity_category.save
    redirect_to activity_categories_url
  end

  def update
    authorize! :manage_activity_categories, ActivityCategory
    @activity_category = nil
    current_activity_category = ActivityCategory.find(params[:id])
    if current_activity_category.is_defined?
      @activity_category = current_activity_category.dup
    else
      @activity_category = current_activity_category
    end

    if @activity_category.update_attributes(params[:activity_category])
      flash[:notice] = "Activity category was successfully updated."
      redirect_to redirect("/projects_global_params#tabs-4")
    else
      render action: "edit"
    end
  end

  def destroy
    authorize! :manage_activity_categories, ActivityCategory
    @activity_category = ActivityCategory.find(params[:id])
    if @activity_category.is_defined?
      #logical deletion: delete don't have to suppress records anymore on defined record
      @activity_category.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
    else
      @activity_category.destroy
    end

    redirect_to redirect(activity_categories_url)
  end
end
