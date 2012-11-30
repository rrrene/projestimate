require "spec_helper"

describe Permission do

  before :each do
    @permission = Permission.first
  end

  it "should be valid" do
    @permission.should be_valid
  end

  it "should be not valid without :name" do
    @permission.name = ""
    @permission.should_not be_valid
  end


  it "should be not valid without :is_permission_project" do
    @permission.is_permission_project = ""
    @permission.should_not be_valid
  end

end