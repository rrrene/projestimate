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

  describe "On master" do
    it " After Duplicate wbs activity ratio element: record status should be proposed" do
      MASTER_DATA=true
      @wbs_activity_ratio_element2=@wbs_activity_ratio_element.amoeba_dup
      if defined?(MASTER_DATA) and MASTER_DATA and File.exists?("#{Rails.root}/config/initializers/master_data.rb")
        @wbs_activity_ratio_element2.record_status.name.should eql("Proposed")
      else
        @wbs_activity_ratio_element2.record_status.name.should eql("Local")
      end
    end
  end

  describe "On local" do
    it "After Duplicate wbs activity ratio element: record status should be local" do
      MASTER_DATA=false
      @wbs_activity_ratio_element2 = @wbs_activity_ratio_element.amoeba_dup
      if defined?(MASTER_DATA) and MASTER_DATA and File.exists?("#{Rails.root}/config/initializers/master_data.rb")
        @wbs_activity_ratio_element2.record_status.name.should eql("Proposed")
      else
        @wbs_activity_ratio_element2.record_status.name.should eql("Local")
      end
    end
  end

end
