require "spec_helper"

describe ProjectSecurity do
  before :each do
    @project_security_level = FactoryGirl.create(:project_security_level)
    @project_security = FactoryGirl.create(:project_security)
    @project_security.project_security_level_id= @project_security_level.id
   end

  it "should return '-' if level is nil" do
    @project_security.project_security_level_id=nil
    @project_security.level.should match('-')
  end

  it "should return level name if level is not nil" do
    @project_security.level.should match(@project_security_level.name)
  end
end