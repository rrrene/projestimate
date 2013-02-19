class WbsActivityRatiosController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

  def export
    @wbs_activity_ratio = WbsActivityRatio.find(params[:wbs_activity_ratio_id])
    csv_string = WbsActivityRatio::export(@wbs_activity_ratio.id)
    send_data(csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=#{@wbs_activity_ratio.name}.csv")
  end

  def import
    @wbs_activity_ratio = WbsActivityRatio.find(params[:wbs_activity_ratio_id])
    begin
      error_count = WbsActivityRatio::import(params[:file], params[:separator], params[:encoding])
    rescue
      flash[:error] = "Failed to import some element that looks out of the WBS-activity."
      redirect_to edit_wbs_activity_path(@wbs_activity_ratio.wbs_activity, :anchor => "tabs-3") and return
    end

    ratio_elements = @wbs_activity_ratio.wbs_activity_ratio_elements
    total = ratio_elements.reject{|i| i.ratio_value.nil? or i.ratio_value.blank? }.compact.sum(&:ratio_value)

    if error_count != 0
      flash[:error] = "Failed to import some element that looks out of the WBS-activity."
    elsif total != 100
      flash[:warning] = "Warning - Ratios successfully imported, but sum is different of 100%."
    elsif error_count == 0 and total == 100
      flash[:notice] = "Ratios successfully imported."
    end

    redirect_to edit_wbs_activity_path(@wbs_activity_ratio.wbs_activity, :anchor => "tabs-3")
  end

  def edit
    set_page_title "Edit wbs-activity ratio"
    @wbs_activity_ratio = WbsActivityRatio.find(params[:id])
    @reference_values =ReferenceValue.all.map{|i| [i.value, i.id]}
  end


  def update
    @wbs_activity_ratio = nil
    current_wbs_activity_ratio = WbsActivityRatio.find(params[:id])

    if current_wbs_activity_ratio.is_defined?
      @wbs_activity_ratio = current_wbs_activity_ratio.amoeba_dup
      @wbs_activity_ratio.owner_id = current_user.id
    else
      @wbs_activity_ratio = current_wbs_activity_ratio
    end

    unless is_master_instance?
      if @wbs_activity_ratio.is_local_record?
        @wbs_activity_ratio.custom_value = "Locally edited"
      end
    end

    if @wbs_activity_ratio.update_attributes(params[:wbs_activity_ratio])
      redirect_to redirect(edit_wbs_activity_path(@wbs_activity_ratio.wbs_activity, :anchor => "tabs-3"))
    else
      render :edit
    end
  end

  def new
    set_page_title "New wbs-activity ratio"
    @wbs_activity_ratio = WbsActivityRatio.new
  end

  def create
    @wbs_activity_ratio = WbsActivityRatio.new(params[:wbs_activity_ratio])

    #If we are on local instance, Status is set to "Local"
    unless is_master_instance?   #so not on master
      @wbs_activity_ratio.record_status = @local_status
    end

    if @wbs_activity_ratio.save

      @wbs_activity_ratio.wbs_activity.wbs_activity_elements.each do |wbs_activity_element|
        WbsActivityRatioElement.create(:ratio_value => nil,
                                       :ratio_reference_element => false,
                                       :wbs_activity_ratio_id => @wbs_activity_ratio.id,
                                       :wbs_activity_element_id => wbs_activity_element.id,
                                       :record_status_id => @wbs_activity_ratio.record_status_id)
      end
      redirect_to redirect(edit_wbs_activity_path(@wbs_activity_ratio.wbs_activity, :anchor => "tabs-3"))
    else
      render :new
    end
  end

  def destroy
    @wbs_activity_ratio = WbsActivityRatio.find(params[:id])
    if is_master_instance?
      if @wbs_activity_ratio.draft? || @wbs_activity_ratio.is_retired?
        @wbs_activity_ratio.destroy
      elsif @wbs_activity_ratio.defined?
        @wbs_activity_ratio.state = "retired"
        @wbs_activity_ratio.save
      else
        flash[:notice] = "It's impossible to delete a retired activity"
      end
    else
      if @wbs_activity_ratio.is_local_record? || @wbs_activity_ratio.is_retired?
        @wbs_activity_ratio.destroy
      else
        flash[:error] = "Master record can not be deleted, it is required for the proper functioning of the application"
       redirect_to redirect(edit_wbs_activity_path(@wbs_activity_ratio.wbs_activity, :anchor => "tabs-3")) and return
      end
    end

    flash[:success] = "WBS-Activity was successfully deleted."
    redirect_to redirect(edit_wbs_activity_path(@wbs_activity_ratio.wbs_activity, :anchor => "tabs-3"))
  end
end
