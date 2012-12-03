require "spec_helper"

describe UsersController, "Creating and managing user", :type => :controller do

  before  do
    @attributes =  { :first_name => "Administrator", :last_name => "Projestimate", :login_name => "admin", :initials => "ad", :email => "youremail@yourcompany.net", :auth_type => AuthMethod.first.id, :user_status => "active" }  #,  :user.password => "projestimate", :password_confirmation => "projestimate"
    #@user = mock_model(User)
    #@user = stub_model(User)
    @created_user = User.first
    #User.should_receive(:new).with(@attributes).once.and_return(@user)
  end

  describe "GET #index" do
    it "populates an array of users" do
      user = @created_user
      get :index
      assigns(:users).should eq([user])
    end

    it "should has a 200 status code" do
      get :index
      expect(response.code).to eq("200")
    end

    #TODO
    #it "should redirect to / if user is not authorised" do
    #  expect(response).to redirect_to(root_url)
    #end
  end


  describe "GET #show" do

  end

  describe "GET #new" do

  end

  describe "POST #create" do

  end

  describe "POST #create_inactive_user" do

  end


  describe "POST #update" do

  end
  describe "GET #new" do

  end
end