require 'spec_helper'

describe WbsActivity do

  before :each do
    @wbs_activity = FactoryGirl.create(:wbs_activity)
  end

  it "should be valid" do
    @wbs_activity.should be_valid
  end

  it "should not be valid without name" do
    @wbs_activity.name = ""
    @wbs_activity.should_not be_valid
  end

  it "should not be valid without uuid" do
    @wbs_activity.uuid = ""
    @wbs_activity.should_not be_valid
  end

  it "should not be valid without custom_value when record_status = Custom" do
    @custom_status = FactoryGirl.build(:custom_status)
    @wbs_activity.record_status = @custom_status
    @wbs_activity.custom_value = ""
    @wbs_activity.should_not be_valid
  end

end
