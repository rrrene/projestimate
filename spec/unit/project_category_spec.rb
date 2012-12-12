require "spec_helper"

describe ProjectCategory do
  before :each do
    @project_category = FactoryGirl.create(:ProjectCategory)
  end

  it "should be valid" do
    @project_category.should be_valid
  end

  #it "should be not valid" do
  #  @project_category.to_s(1).should_not be_valid
  #end
end