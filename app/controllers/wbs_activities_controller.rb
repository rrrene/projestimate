class WbsActivitiesController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses
  helper_method :wbs_record_statuses_collection

  def import
    begin

      WbsActivityElement.import(params[:file], params[:separator])
      flash[:notice] = "Import successful."
    rescue
      flash[:error] = "Please verify file integrity. You use illegal character like carriage return or double quotes in your csv files."
    end
    redirect_to wbs_activities_path
  end

  def refresh_ratio_elements
    @wbs_activity_ratio_elements = WbsActivityRatioElement.where(:wbs_activity_ratio_id => params[:wbs_activity_ratio_id]).all
  end

  def index
    set_page_title "WBS activities"
    @wbs_activities = WbsActivity.all
  end

  def edit
    set_page_title "WBS activities"
    @wbs_activity = WbsActivity.find(params[:id])
    @wbs_activity_elements = WbsActivityElement.where(:wbs_activity_id => @wbs_activity.id).paginate(:page => params[:page], :per_page => 30)
    @wbs_activity_ratios = WbsActivityRatio.where(:wbs_activity_id => @wbs_activity.id)
    if params[:current_ratio_id]
      @wbs_activity_ratio_elements = WbsActivityRatioElement.where(:wbs_activity_ratio_id => params[:current_ratio_id]).all
    else
      if @wbs_activity.wbs_activity_ratios.empty?
        @wbs_activity_ratio_elements = []
      else
        @wbs_activity_ratio_elements = WbsActivityRatioElement.where(:wbs_activity_ratio_id => @wbs_activity.wbs_activity_ratios.first.id).all
      end
    end

    unless is_master_instance?
      if @wbs_activity.is_defined?
        flash[:error] = "Master record can not be deleted, it is required for the proper functioning of the application"
        redirect_to wbs_activities_path  and return
      elsif @wbs_activity.defined?
        flash[:error] = "It's impossible to edit a defined activity"
        redirect_to wbs_activities_path
      end
    end
  end

  def update
    @wbs_activity = nil
    @wbs_activity = WbsActivity.find(params[:id])

    if @wbs_activity.is_defined? && is_master_instance?
      @wbs_activity.owner_id = current_user.id
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
    if is_master_instance?
      @wbs_activity.record_status = @proposed_status
      @wbs_activity.state = "defined"
     else #so not on master
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
      if @wbs_activity.is_defined?
        @wbs_activity.update_attribute(:record_status_id, @retired_status.id)
      else
        @wbs_activity.destroy
      end
    else
      if @wbs_activity.is_local_record? #|| @wbs_activity.is_retired?
        if @wbs_activity.defined?
          @wbs_activity.update_attribute(:state, "retired")
        else
            @wbs_activity.destroy
        end
      else
        flash[:error] = "Master record can not be deleted, it is required for the proper functioning of the application"
        redirect_to redirect(wbs_activities_path)  and return
      end
    end

    flash[:success] = "WBS-Activity was successfully deleted."
    redirect_to wbs_activities_path
  end


  #Method to duplicate WBS-Activity and associated WBS-Activity-Elements
  def duplicate_me
    #begin
      old_wbs_activity = WbsActivity.find(params[:wbs_activity_id])

      new_wbs_activity = old_wbs_activity.amoeba_dup   #amoeba gem is configured in WbsActivity class model
      if is_master_instance?
        new_wbs_activity.record_status = @proposed_status
        new_wbs_activity.state = "defined"
      else
        new_wbs_activity.state = "draft"

      end
      if new_wbs_activity.save
        old_wbs_activity.save  #Original WbsActivity copy number will be incremented to 1

        #Managing the compoment tree
        new_wbs_activity_elements = new_wbs_activity.wbs_activity_elements

        new_wbs_activity_elements.each do |new_elt|
          unless new_elt.is_root?
            new_ancestor_ids_list = []
            new_elt.ancestor_ids.each do |ancestor_id|
              ancestor_id = WbsActivityElement.find_by_wbs_activity_id_and_copy_id(new_elt.wbs_activity_id, ancestor_id).id
              new_ancestor_ids_list.push(ancestor_id)
            end
            new_elt.ancestry = new_ancestor_ids_list.join('/')
            new_elt.save
          end
        end
        #raise "#{RuntimeError}"
      end

      #flash[:notice] = "WBS-Activity was successfully duplicated"
      redirect_to "/wbs_activities" and return
    #rescue
    #  flash[:notice] = "Duplication failed: Error happened on Wbs-Activity duplication"
    #  redirect_to "/wbs_activities"
    #end
  end

  def wbs_record_statuses_collection
    if @wbs_activity.new_record?
      if is_master_instance?
        @wbs_record_status_collection = RecordStatus.where("name = ?", "Proposed")
      else
        @wbs_record_status_collection = RecordStatus.where("name = ?", "Local")
      end
    else
      @wbs_record_status_collection = []
      if @wbs_activity.is_defined?
        @wbs_record_status_collection = RecordStatus.where("name = ?", "Defined")
      else
        @wbs_record_status_collection = RecordStatus.where("name <> ?", "Defined")
      end
    end
  end

end
