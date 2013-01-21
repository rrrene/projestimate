# This module is used to avoid login repetition while testing controller methods


module ControllerMacros

  #def login_as_admin
  #  before :each do
  #    @request.env["devise.mapping"] = Devise.mappings[:user]
  #    auth_method = FactoryGirl.create(:auth_method)
  #    language = FactoryGirl.create(:en_language)
  #    user = FactoryGirl.create(:user, :first_name => "Administrator", :last_name => "Projestimate", :initials => "ad", :login_name => "admin", :email => "admin@gmail.com", :user_status => "active", :auth_method => auth_method, :language => language)
  #    sign_in user
  #  end
  #end
  #
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