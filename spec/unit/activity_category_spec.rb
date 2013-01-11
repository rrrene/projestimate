require "spec_helper"

describe ActivityCategory do
  before :each do
    @activity_category = FactoryGirl.create(:activity_category)
    @custom_status = FactoryGirl.build(:custom_status)
  end

  it 'should be valid' do
    @activity_category.should be_valid
  end

  it "should be not valid without :name" do
    @activity_category.name = ""
    @activity_category.should_not be_valid
  end

  it "should be not valid without :description" do
    @activity_category.description = ""
    @activity_category.should_not be_valid
  end

  it "should be not valid without :alias" do
    @activity_category.description = ""
    @activity_category.should_not be_valid
  end

  it "should not be valid without UUID" do
    @activity_category.uuid = ""
    @activity_category.should_not be_valid
  end

  it "should not be valid without record status" do
    @activity_category.record_status = nil
    @activity_category.should_not be_valid
  end

  it "should not be valid without custom_value when record_status='Custom'" do
    @activity_category.record_status = @custom_status
    @activity_category.should_not be_valid
  end

  specify "should return :acquisition_category name" do
    @activity_category.to_s.should eql(@activity_category.name)
  end

end