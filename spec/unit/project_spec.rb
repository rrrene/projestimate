require "spec_helper"

describe Project do

  before :each do
    @project = FactoryGirl.create(:project, :title => "projet11", :alias => "P11")
    @user = FactoryGirl.build(:user)

    @user1 = User.new(:last_name => 'Projestimate', :first_name => 'Administrator', :login_name => 'admin1', :email => 'youremail1@yourcompany.net', :user_status => 'active', :auth_type => AuthMethod.first.id, :password => 'test', :password_confirmation => 'test')
    #@project1 = Project.new(:title => 'Projet1', :description => 'projet numero 1', :alias => 'P1', :state => 'preliminary')
    @project1 = FactoryGirl.build(:project)
    @project_security_1 = ProjectSecurity.new(:project_id => @project1.id, :user_id => @user1.id)
    @project_security = ProjectSecurity.new(:project_id => @project.id, :user_id => @user1.id)
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
    @user.projects = [@project]
    @user.projects.should include(@project)
  end

  it "should return valid string" do
    @project1.to_s.should eql(@project1.title + ' - ' + @project1.description.truncate(20))
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

  it "should return all possible states" do
    project1 = FactoryGirl.create(:project)
    project1.states.should eql(Project.aasm_states_for_select)
  end


  #OTHERS TESTS

  it "should return his root pbs_project_element" do
    #@project1.root_component.id.should eql(@project1.pe_wbs_project.pbs_project_elements.first.id)
  end

  it "should return the good WBS attached to the project" do
    project = FactoryGirl.create(:project)
    pe_wbs_project = FactoryGirl.create(:wbs_1, :project_id => project.id)

    #pe_wbs_project.project.should eql(project1)
    project.pe_wbs_project.project_id.should eql(project.id)
  end

  it "should be the project root pbs_project_element" do

    project = FactoryGirl.create(:project)
    pe_wbs_project_1 = FactoryGirl.create(:wbs_1, :project_id => project.id)

    pbs_project_element = FactoryGirl.create(:pbs_project_element, :folder, :is_root => true, :pe_wbs_project => pe_wbs_project_1)
    #pbs_project_element.pe_wbs_project = pe_wbs_project_1

    #project.root_component.is_root?.should be_true
    project.root_component.should eq(pbs_project_element)
  end


  it "should return a good project attribute value" do
     #TODO
  end

  it "should execute correctly a estimation plan" do
     #
  end

  it "should be a folder componenet" do
    project = FactoryGirl.create(:project)
    pe_wbs_project = FactoryGirl.create(:wbs_1, :project_id => project.id)
    #peicon_folder = FactoryGirl.create(:peicon_folder)
    #peicon_link = FactoryGirl.create(:peicon_link)
    #wet_folder = FactoryGirl.create(:work_element_type_folder, :peicon => FactoryGirl.create(:peicon_folder))

    #project.pe_wbs_project.pbs_project_elements << FactoryGirl.create(:pbs_project_element_folder)
    #project.pe_wbs_project.pbs_project_elements << FactoryGirl.create(:pbs_project_element_link)

    project.pe_wbs_project.pbs_project_elements.each do |pc|
      pc.work_element_type.name.should eql("Folder")
    end
  end

  it "should return an array of folder" do
    project = FactoryGirl.create(:project)
    pe_wbs_project = FactoryGirl.create(:wbs_1, :project_id => project.id)
    project.folders.should eql(project.pe_wbs_project.pbs_project_elements.select{|i| i.folder? })
  end

  it "should return table search" do
    Project::table_search("").should be_kind_of(ActiveRecord::Relation)
    Project::table_search("").should be_an_instance_of(ActiveRecord::Relation)
  end


  after :each do
    #clean up
  end

end