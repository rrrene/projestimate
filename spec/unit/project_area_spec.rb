require "spec_helper"

describe ProjectArea do
  before :each do
    @project_area = FactoryGirl.create(:project_area)
    @custom_status = FactoryGirl.build(:custom_status)
  end

  it "should be valid" do
    @project_area.should be_valid
  end

  it "should not be valid without record_status" do
    @project_area.record_status = nil
    @project_area.should_not be_valid
  end

  it "should not be valid without custom_value when record_status='Custom'" do
    @project_area.record_status = @custom_status
    @project_area.should_not be_valid
  end

  it "should not be a string" do
    @project_area.name=1
    @project_area.to_s.should_not be_instance_of(String)
  end

  it "should a string" do
    @project_area.to_s.should be_an_instance_of(String)
  end

  it "should return project Area name" do
    @project_area.to_s.should eql(@project_area.name)
  end
end