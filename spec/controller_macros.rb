# This module is used to avoid login repetition while testing controller methods
module ControllerMacros

  def login_as_admin
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      auth_method = FactoryGirl.create(:auth_method)
      language = FactoryGirl.create(:language)
      user = FactoryGirl.create(:user,
                                :first_name => "Administrator",
                                :last_name => "Projestimate",
                                :initials => "ad",
                                :login_name => "admin",
                                :email => "admin@gmail.com",
                                :user_status => "active",
                                :auth_method => auth_method,
                                :language => language)
      sign_in user
    end
  end

  def login_as_user
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      sign_in user
    end
  end
end