require "spec_helper"

describe ProjectCategory do
  before :each do
    @project_category = FactoryGirl.create(:ProjectCategory)
  end

  it "should be valid" do
    @project_category.should be_valid
  end

  it "should be a string" do
    @project_category.name=1
    @project_category.to_s.should_not be_instance_of(String)
  end

  it "should not be a string" do
    @project_category.to_s.should be_an_instance_of(String)
  end

  it "should return project Category name" do
    @project_category.to_s.should eql(@project_category.name)
  end

end



