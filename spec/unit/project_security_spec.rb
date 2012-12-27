require "spec_helper"

describe ProjectSecurity do

  before :each do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project)
    @project_security_level = FactoryGirl.create(:readOnly_project_security_level)

    #@project_security = FactoryGirl.create(:project_security)
    #@project_security.project_security_level_id= @project_security_level.id
    @project_security = ProjectSecurity.create(:user => @user, :project => @project, :project_security_level => @project_security_level)
   end

  it "should return '-' if level is nil" do
    @project_security.project_security_level_id=nil
    @project_security.level.should match('-')
  end

  it "should return level name if level is not nil" do
    @project_security.level.should match(@project_security_level.name)
  end
end