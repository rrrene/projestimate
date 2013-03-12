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

  describe "Duplicate wbs activity" do
    before do
      @wbs_activity_2 = @wbs_activity.amoeba_dup
      @wbs_activity_2.save
      @wbs_activity.save
    end

    it "should return copy name" do
      @wbs_activity_2.name.should eql("Copy_#{@wbs_activity.copy_number.to_i} of #{@wbs_activity.name}")
    end

    it "Should return copy number = 0" do
      @wbs_activity_2.copy_number.should eql(0)
    end

    it "Should update the copy number" do
      @wbs_activity.copy_number.should eql(@wbs_activity.copy_number.to_i)
    end
  end
end
