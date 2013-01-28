class WbsActivitiesController < ApplicationController
  def index
    set_page_title "WBS activities"
    @wbs_activities = WbsActivity.all
  end

  def edit
    set_page_title "WBS activities"
    @wbs_activity = WbsActivity.find(params[:id])
    if @wbs_activity.defined?
      flash[:notice] = "It's impossible to edit a defined activity"
      redirect_to wbs_activities_path
    end
  end

  def update
    @wbs_activity = WbsActivity.find(params[:id])
    if @wbs_activity.update_attributes(params[:wbs_activity])
      redirect_to wbs_activities_path
    else
      render :edit
    end
  end

  def new
    set_page_title "WBS activities"
    @wbs_activity = WbsActivity.new
  end

  def create
    @wbs_activity = WbsActivity.new(params[:wbs_activity])
    if @wbs_activity.save
      redirect_to wbs_activities_path
    else
      render :new
    end
  end

  def destroy
    @wbs_activity = WbsActivity.find(params[:id])
    if @wbs_activity.draft?
      @wbs_activity.delete
    elsif @wbs_activity.defined?
      @wbs_activity.state = "retired"
      @wbs_activity.save
    else
      flash[:notice] = "It's impossible to delete a retired activity"
    end
    redirect_to wbs_activities_path
  end
end
