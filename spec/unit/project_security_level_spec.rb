require "spec_helper"

describe ProjectSecurityLevel do
  before :each do
    @project_security_level = FactoryGirl.create(:readOnly_project_security_level)
  end

  it "should be valid" do
    @project_security_level.should be_valid
  end

end