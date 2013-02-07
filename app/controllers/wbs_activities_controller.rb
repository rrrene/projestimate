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

    if is_master_instance?
      if @wbs_activity.is_defined?
        @wbs_activity.record_status = @proposed_status
      end
      unless @wbs_activity.child_reference.nil?
        if @wbs_activity.child_reference.is_proposed_or_custom?
          flash[:notice] = "This Wbs-Activity can't be edited, because the previous changes have not yet been validated."
          redirect_to wbs_activities_path and return
        end
      end
    else
      if @wbs_activity.defined?
        flash[:notice] = "It's impossible to edit a defined activity"
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

end
