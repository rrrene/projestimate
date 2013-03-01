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
    #set ratio values
    ratio_values = params[:ratio_values]
    ratio_values.each do |i|
      w = WbsActivityRatioElement.find(i.first)
      if w.wbs_activity_ratio.is_All_Activity_Elements?
        if i.last.blank?
           flash[:custom] = "Please insert ratio value"
        elsif i.last.to_i <=0 or i.last.to_i>100
           flash[:custom] = "Please, enter value between 0 and 100"
        else
          #
        end
      else
        if i.last.to_i <= 0 or i.last.to_i>100
          flash[:custom] = "Please, enter value between 0 and 100"
        end
      end
      w.ratio_value = i.last

      w.save(:validate => false)
    end

    #Select ratio and elements
    wbs_activity_ratio = WbsActivityRatio.find(params[:wbs_activity_ratio_id])
    ratio_elements = wbs_activity_ratio.wbs_activity_ratio_elements

    #keep current ratio
    @selected_ratio = wbs_activity_ratio
    @wbs_activity_ratio_elements = wbs_activity_ratio.wbs_activity_ratio_elements

    #sum total ratio_value
    @total = ratio_elements.reject{|i| i.ratio_value.nil? or i.ratio_value.blank? }.compact.sum(&:ratio_value)

    #set ratio reference (all to false then one to true)
    wbs_activity_ratio.wbs_activity_ratio_elements.each do |wbs_activity_ratio_element|
      wbs_activity_ratio_element.update_attribute("ratio_reference_element",  false)
    end

    if wbs_activity_ratio.is_A_Set_Of_Activity_Elements?
      if params[:ratio_reference_elements]
        params[:ratio_reference_elements].each do |p|
          new_ref = WbsActivityRatioElement.find_by_id(p)
          new_ref.update_attribute("ratio_reference_element", true)
        end
      else
        flash[:error] = "Please, select a reference element."
      end
    else
      if params[:ratio_reference_element]
        new_ref = WbsActivityRatioElement.find_by_id_and_wbs_activity_ratio_id(params[:ratio_reference_element], params[:wbs_activity_ratio_id])
        new_ref.update_attribute("ratio_reference_element", true)
      else
        flash[:error] = "Please, select a reference element."
      end
    end
    #we test total
    if @total != 100
      flash[:warning] = "Warning - Ratios successfully saved, but sum is different of 100%"
    else
      flash[:notice] = "Ratios successfully saved"
    end

  end



end
