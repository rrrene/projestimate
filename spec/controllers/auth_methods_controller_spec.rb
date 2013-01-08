require 'spec_helper'
describe AuthMethodsController do
  before :each do
    @default_auth_method = FactoryGirl.create(:auth_method)
    proposed_status = FactoryGirl.build(:proposed_status)
    @another_auth_method = AuthMethod.new(:name => "LDAP", :server_name => "example.com", :port => 636, :base_dn => "something", :certificate => "simple_tls", :uuid => "124563", :record_status => proposed_status)
  end
  describe "GET index" do
    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
    it "assigns all default_auth_method as @default_auth_method" do
      get :index
      assigns(:default_auth_method)==(@default_auth_method)
    end
  end
  describe "New" do
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end
    #it "assigns a new default_auth_method as @default_auth_method" do
    #  get :new
    #  assigns(:default_auth_method).should be_a_new_record
    #end
  end

  describe "GET edit" do
    it "assigns the requested default_auth_method as @default_auth_method" do
      get :edit, {:id => @default_auth_method.to_param}
      assigns(:default_auth_method)==([@default_auth_method])
    end
  end

  describe "DELETE destroy" do
    #it "redirects to the admin_setting list" do
    #  delete :destroy, {:id => :admin_setting.to_param}
    #  response.should redirect_to(admin_settings_path)
    #end
    #it "destroys the requested admin_setting" do
    #  expect {
    #    delete :destroy, {:id => :admin_setting.to_param}
    #  }.to change(AdminSetting, :count).by(-1)
    #end

  end
end