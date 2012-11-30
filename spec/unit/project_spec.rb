require "spec_helper"

describe Project do

  before :each do
    #@project = Factory.build :project
    @project = Project.first
    @another_project = Project.first
    @user = User.first

    @user1 = User.new(:last_name => 'Projestimate', :first_name => 'Administrator', :login_name => 'admin1', :email => 'youremail1@yourcompany.net', :user_status => 'active', :auth_type => AuthMethod.first.id, :password => 'test', :password_confirmation => 'test')
    @project1 = Project.new(:title => 'Projet1', :description => 'projet numero 1', :alias => 'P1', :state => 'preliminary')
    @project_security_1 = ProjectSecurity.new(:project_id => @project1.id, :user_id => @user1.id)
    @project_security = ProjectSecurity.new(:project_id => @project.id, :user_id => @user.id)
  end

  before :all do
    @user2 = User.new(:last_name => 'Projestimate', :first_name => 'Administrator', :login_name => 'admin2', :email => 'youremail2@yourcompany.net', :user_status => 'active', :auth_type => 6, :password => 'test', :password_confirmation => 'test')
    @project2 = Project.new(:title => 'Projet1', :description => 'projet numero 1', :alias => 'P1', :state => 'preliminary')
    @project2_security = ProjectSecurity.new(:project_id => @project2.id, :user_id => @user2.id)
  end

  it 'should be a valid project' do
    @project.should be_valid
  end

  specify "should be a valid user (user1)" do
    @user1.should be_valid
  end

  specify "should be a valid user (user2)" do
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

  it "should not be valid when title already exists" do
    p1 = @project.dup
    p1.title = @project.title
    p1.save
    p1.should_not be_valid
  end

  it "should not be valid when alias already exists" do
    p1 = @project.dup
    p1.alias = @project.alias
    p1.save
    p1.should_not be_valid
  end

  it "should be in preliminary state" do
    @project.state.should eql('preliminary')
    @project.should be_valid
  end

  it "should be present in user's project list" do
    #@project.users.count.should eql(1)
    #@project.should be_valid
    @user.projects.should include(@project)
  end

  it "should return valid string" do
    @project.to_s.should eql(@project.title + ' - ' + @project.description.truncate(20))
  end


  #ASSM STATES

  it 'should have 7 states' do
    Project.aasm_states_for_select.size.should eql(7)
  end

  it "should change project state when transition" do
    lambda { @project1.commit! }.should change(@project1, :state).from('preliminary').to('in_progress')
    lambda { @project1.commit! }.should change(@project1, :state).from('in_progress').to('in_review')
    lambda { @project1.commit! }.should change(@project1, :state).from('in_review').to('baseline')
    @project1.state = "private"
    lambda { @project1.commit! }.should change(@project1, :state).from('private').to('baseline')
  end


  #OTHERS TESTS

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