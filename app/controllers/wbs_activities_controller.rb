class WbsActivitiesController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

  def index
    set_page_title "WBS activities"
    @wbs_activities = WbsActivity.all
  end

  def edit
    set_page_title "WBS activities"
    @wbs_activity = WbsActivity.find(params[:id])


    if @wbs_activity.defined?
      flash[:notice] = "It's impossible to edit a defined activity"
      redirect_to wbs_activities_path and return
    end

    unless @wbs_activity.child_reference.nil?
      if @wbs_activity.child_reference.is_proposed_or_custom?
        flash[:notice] = "This Wbs-Activity can't be edited, because the previous changes have not yet been validated."
        redirect_to wbs_activities_path and return
      end
    end

  end


  def update
    @wbs_activity = nil
    current_wbs_activity = WbsActivity.find(params[:id])

    if current_wbs_activity.is_defined?
      @wbs_activity = current_wbs_activity.amoeba_dup
      @wbs_activity.owner_id = current_user.id
    else
      @wbs_activity = current_wbs_activity
    end

    unless is_master_instance?
      if @wbs_activity.is_local_record?
        @wbs_activity.custom_value = "Locally edited"
      end
    end

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
    #If we are on local instance, Status is set to "Local"
    unless is_master_instance?   #so not on master
      @wbs_activity.record_status = @local_status
    end

    if @wbs_activity.save

      if @wbs_activity.is_local_record?
        @wbs_activity_element = WbsActivityElement.new(:name => @wbs_activity.name, :wbs_activity => @wbs_activity, :description => 'Root Element', :record_status => @local_status)
      else
        @wbs_activity_element = WbsActivityElement.new(:name => @wbs_activity.name, :wbs_activity => @wbs_activity, :description => 'Root Element', :record_status => @proposed_status)
      end

      @wbs_activity_element.save

      redirect_to wbs_activities_path
    else
      render :new
    end
  end

  def destroy
    @wbs_activity = WbsActivity.find(params[:id])
    if is_master_instance?
      if @wbs_activity.draft? || @wbs_activity.is_retired?
        @wbs_activity.delete
      elsif @wbs_activity.defined?
        @wbs_activity.state = "retired"
        @wbs_activity.save
      else
        flash[:notice] = "It's impossible to delete a retired activity"
      end
    else
      if @wbs_activity.is_local_record? || @wbs_activity.is_retired?
        @wbs_activity.destroy
      else
        flash[:error] = "Master record can not be deleted, it is required for the proper functioning of the application"
        redirect_to redirect(wbs_activities_path)  and return
      end
    end

    flash[:success] = "WBS-Activity was successfully deleted."
    redirect_to wbs_activities_path
  end
end
