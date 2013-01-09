require 'spec_helper'
describe ProjectsController do
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

  describe "GET index" do
    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
    it "assigns all projects as @projects" do
      get :index
      assigns(:project)==(@project1)
    end
  end
  describe "New" do
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end
    #it "assigns a new attributes as @attribute" do
    #  get :new
    #  assigns(:ksloc_attribute).should be_a_new_record
    #end
  end
  describe "Create" do
    it "renders the create template" do
      get :new
      response.should render_template("new")
    end
  end
  #describe "GET edit" do
  #  it "assigns the requested project as @project" do
  #    get :edit, {:id => @projects.to_param}
  #    assigns(:project)==(@project1)
  #  end
  #end
  #describe "PUT update" do
  #end
  #
  #describe "POST create" do
  #end
  #
  #describe "DELETE destroy" do
  #
  #  it "redirects to the project list" do
  #    delete :destroy, {:id => @attribute.to_param}
  #    response.should redirect_to(session[:return_to])
  #  end
  #end


end