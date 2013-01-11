require "spec_helper"

describe Permission do

  before :each do
    #@permission = Permission.first
    @permission = FactoryGirl.create(:permission)
    @custom_status = FactoryGirl.build(:custom_status)
  end

  it "should be valid" do
    @permission.should be_valid
  end

  it "should be not valid without :name" do
    @permission.name = ""
    @permission.should_not be_valid
  end

  it "should not be valid without custom_value when record_status='Custom'" do
    @permission.record_status = @custom_status
    @permission.should_not be_valid
  end

  it "should be not valid without :is_permission_project" do
    @permission.is_permission_project = ""
    @permission.should_not be_valid
  end

end