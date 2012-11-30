require "spec_helper"

describe UsersController, "creating a new user" do

  before  do
    @attributes =  { :first_name => "Administrator", :last_name => "Projestimate", :login_name => "admin", :initials => "ad", :email => "youremail@yourcompany.net", :auth_type => AuthMethod.first.id, :user_status => "active" }  #,  :user.password => "projestimate", :password_confirmation => "projestimate"
    @user = mock_model(User)
    User.should_receive(:new).with(@attributes).once.and_return(@user)
  end

  describe "GET #index" do
=begin
    it "populates an array of users" do
      user = @user
      get :index
      assigns(:users).should eql([user])
    end
=end
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