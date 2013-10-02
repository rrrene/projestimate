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
    @project_security.level.should eql('-')
  end

  it "should return level name if level is not nil" do
    @project_security.level.should eql(@project_security_level.name)
  end

  it "should return id" do
    @project_security.to_s.should eql(@project_security.id.to_s)
  end
end