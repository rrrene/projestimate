require 'spec_helper'

describe WbsActivityRatioElement do

  before :each do
    @wbs_activity = FactoryGirl.create(:wbs_activity)
    @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio, :wbs_activity => @wbs_activity)
    @wbs_activity_ratio_element = FactoryGirl.create(:wbs_activity_ratio_element, :wbs_activity_ratio => @wbs_activity_ratio)
  end

  it "should be valid" do
    @wbs_activity_ratio_element.should be_valid
  end

  it "should not be valid without uuid" do
    @wbs_activity_ratio_element.uuid = ""
    @wbs_activity_ratio_element.should_not be_valid
  end

end
