require "spec_helper"

describe ProjectSecurityLevel do
  before :each do
    @project_security_level = FactoryGirl.create(:readOnly_project_security_level)
    @custom_status = FactoryGirl.build(:custom_status)
  end

  it "should be valid" do
    @project_security_level.should be_valid
  end

  it "should not be valid without custom_value when record_status='Custom'" do
    @project_security_level.record_status = @custom_status
    @project_security_level.should_not be_valid
  end

end