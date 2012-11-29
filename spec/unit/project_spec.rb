require "spec_helper"

describe Project do

  before :each do
    #@project = Factory.build :project
    @project = Project.first
    @another_project = Project.first

    @user1 = User.new(:last_name => 'Projestimate', :first_name => 'Administrator', :login_name => 'admin', :email => 'youremail@yourcompany.net', :user_status => 'active', :auth_type => 6, :password => 'test', :password_confirmation => 'test')
    @project1 = Project.new(:title => 'Projet1', :description => 'projet numero 1', :alias => 'P1', :state => 'preliminary')
    @project_security = ProjectSecurity.new(:project_id => @project1.id, :user_id => @user1.id)
    @project1_security = ProjectSecurity.new(:project_id => @project.id, :user_id => @user1.id)
  end


  before :all do
    @user2 = User.new(:last_name => 'Projestimate', :first_name => 'Administrator', :login_name => 'admin', :email => 'youremail@yourcompany.net', :user_status => 'active', :auth_type => 6, :password => 'test', :password_confirmation => 'test')
    @project2 = Project.new(:title => 'Projet1', :description => 'projet numero 1', :alias => 'P1', :state => 'preliminary')
    @project2_security = ProjectSecurity.new(:project_id => @project2.id, :user_id => @user2.id)
  end

  it 'should be a valid project' do
    @project.should be_valid
  end

  it "should be a valid user (user1)" do
    @user1.should _be_valid
  end

  it "should be a valid user (user2)" do
    @user2.should be_valid
  end

  #validation
  it "should not be valid without title"  do
    @project.title=''
    @project.should_not be_valid
  end

  it "should not be valid without alias"  do
    @project.alias=''
    @project.should_not be_valid
  end

  it "should not be valid without state"  do
    @project.state=''
    @project.should_not be_valid
  end

  it "should be in preliminary state" do
    @project.state.should eql('preliminary')
    @project.should be_valid
  end

  it "should be present in user's project list" do
    @project.users.count.should eql(1)
    @project.should be_valid
  end


  it 'should have 7 states' do
    Project.aasm_states_for_select.size.should eql(7)
  end

  it "should return his root component" do
    @project.root_component.id.should eql(@project.wbs.components.first.id)
  end

  it "should return a good project attribute value" do
     #TODO
  end

  it "should execute correctly a estimation plan" do
     #TODO
  end

  it "should generate a folders array" do
     #TODO
  end

  it "should raise an error" do
     #TODO
  end

  after :each do
    #clean up
  end

end