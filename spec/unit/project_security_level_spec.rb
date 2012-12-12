require "spec_helper"

describe ProjectSecurityLevel do
  before :each do
    @project_security_level = ProjectSecurityLevel.first
  end

  it "should be valid" do
    @project_security_level.should be_valid
  end

end