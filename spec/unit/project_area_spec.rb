require "spec_helper"

describe ProjectArea do
  before :each do
    @project_area = FactoryGirl.create(:project_area)
  end

  it "should be valid" do
    @project_area.should be_valid
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