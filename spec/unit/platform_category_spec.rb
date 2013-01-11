require "spec_helper"

describe PlatformCategory do
  before :each do
    @platform_category = FactoryGirl.create(:unknown_platform_category)
    @custom_status = FactoryGirl.build(:custom_status)
  end

  it "should be valid" do
    @platform_category.should be_valid
  end

  it "should not be valid without name" do
    @platform_category.name = ""
    @platform_category.should_not be_valid
  end

  it "should not be valid without description" do
    @platform_category.description = ""
    @platform_category.should_not be_valid
  end

  it "should not be valid without record_status" do
    @platform_category.record_status = nil
    @platform_category.should_not be_valid
  end

  it "should not be valid without custom_value when record_status='Custom'" do
    @platform_category.record_status = @custom_status
    @platform_category.should_not be_valid
  end

  it "should return platform category name" do
    @platform_category.to_s.should eql(@platform_category.name)
  end
end