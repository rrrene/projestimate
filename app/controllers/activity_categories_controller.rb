class ActivityCategoriesController < ApplicationController

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
    redirect_to activity_categories_url
  end

  def update
    authorize! :manage_activity_categories, ActivityCategory
    @activity_category = ActivityCategory.find(params[:id])
    redirect_to activity_categories_url
  end

  def destroy
    authorize! :manage_activity_categories, ActivityCategory
    @activity_category = ActivityCategory.find(params[:id])
    @activity_category.destroy
    redirect_to activity_categories_url
  end
end
