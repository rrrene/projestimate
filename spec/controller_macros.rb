# This module is used to avoid login repetition while testing controller methods


module ControllerMacros

  def login_as_admin
    #we create other record status
    defined_record_status = RecordStatus.find_or_create_by_name(:name => "Defined", :description => "Test Saly")

    proposed_status = RecordStatus.find_or_create_by_name(:name => "Proposed", :description => "tbd", :record_status_id => defined_record_status.id)
    custom_status = RecordStatus.find_or_create_by_name(:name => "Custom", :description => "tbd", :record_status_id => defined_record_status.id)
    draft_status = RecordStatus.find_or_create_by_name(:name => "Draft", :description => "tbd", :record_status_id => defined_record_status.id)
    retired_status = RecordStatus.find_or_create_by_name(:name => "Retired", :description => "tbd", :record_status_id => defined_record_status.id)
    inReview_status = RecordStatus.find_or_create_by_name(:name => "InReview", :description => "tbd", :record_status_id => defined_record_status.id)
    local_status = RecordStatus.find_or_create_by_name(:name => "Local", :description => "tbd", :record_status_id => defined_record_status.id)

    first_language = Language.first
    if first_language.nil?
      first_language = Language.new(:name => "English", :locale => "EN", :record_status_id => defined_record_status.id)
      first_language.save
    end

    first_auth_method = AuthMethod.first
    if first_auth_method.nil?
      first_auth_method = AuthMethod.new(:name => "Application", :server_name => "Not used", :port => 0, :record_status_id => defined_record_status.id)
      first_auth_method.save
    end

    user = User.new(:first_name => "Projestimate", :last_name => "Administrator", :login_name => "Admin", :email => "admin@example.com", :password => "secret", :password_confirmation => "secret", :language_id => first_language.id, :auth_type => first_auth_method.id, :user_status=>"active")
    user.save
    session[:current_user_id] = user.id
    current_user = user
  end


  #def login_as_admin
  #  before :each do
  #    @request.env["devise.mapping"] = Devise.mappings[:user]
  #    auth_method = FactoryGirl.create(:auth_method)
  #    language = FactoryGirl.create(:en_language)
  #    user = FactoryGirl.create(:user, :first_name => "Administrator", :last_name => "Projestimate", :initials => "ad", :login_name => "admin", :email => "admin@gmail.com", :user_status => "active", :auth_method => auth_method, :language => language)
  #    sign_in user
  #  end
  #end


  #def log_user
  #  auth_method = FactoryGirl.create(:auth_method)
  #  language = FactoryGirl.create(:en_language)
  #  user = FactoryGirl.create(:user, :first_name => "Administrator", :last_name => "Projestimate", :initials => "ad", :login_name => "admin", :email => "admin@gmail.com", :user_status => "active", :auth_method => auth_method, :language => language)
  #  User.anonymous
  #  get "/dashbord"
  #  assert_equal nil, session[:user_id]
  #  assert_response :success
  #  assert_template "account/login"
  #  post "/dashbord", :login_name =>user.login_name, :password => user.password
  #  assert_equal login, User.find(session[:user_id]).login
  #end
  #def login_as_user
  #  before :each do
  #    #@request.env["devise.mapping"] = Devise.mappings[:user]
  #    @user = FactoryGirl.create(:user)
  #    sign_in @user
  #  end
  #end



#def login_as_user!
#  before do
#    auth_method = FactoryGirl.create(:auth_method)
#    language = FactoryGirl.create(:en_language)
#    user = FactoryGirl.create(:user, :auth_method => auth_method, :language => language)
#
#    #user = User.first
#    @current_user = user
#    controller.stub!(:current_user).and_return(@current_user)
#    session[:user_id] = @current_user.id
#  end
#end

#def login_as_admin!
#  before :each do
#    auth_method = FactoryGirl.create(:auth_method, :name => "Application")
#    language = FactoryGirl.create(:en_language)
#    user=FactoryGirl.create(:user, :first_name => "Administrator", :last_name => "Projestimate", :initials => "ad", :login_name => "admin", :email => "admin@gmail.com", :user_status => "active")
#    @current_user = user
#    controller.stub!(:current_user).and_return(@current_user)
#    session[:user_id] = @current_user.id
#  end
#end

end