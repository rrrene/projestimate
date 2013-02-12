class WbsActivityRatioElementsController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

  def edit
    set_page_title "Edit wbs-activity ratio"
    @wbs_activity_ratio_element = WbsActivityRatioElement.find(params[:id])
  end

  def new
    set_page_title "New wbs-activity ratio"
    @wbs_activity_ratio_element = WbsActivityRatioElement.new
  end

  def save_values
    ratio_values = params[:ratio_values]
    ratio_values.each do |i|
      WbsActivityRatioElement.find(i.first).update_attribute('ratio_value', i.last)
    end

    @wbs_activity_ratio = WbsActivityRatioElement.first.wbs_activity_ratio

    total = @wbs_activity_ratio.wbs_activity_ratio_elements.sum(&:ratio_value)
    if total != 100
      flash[:warning] = "Be careful, the total ratio value is not equal to 100."
    else
      flash[:notice] = "Ratio value has been successfully saved."
    end
    redirect_to redirect(edit_wbs_activity_path(@wbs_activity_ratio.wbs_activity))
  end

end
