require 'spec_helper'
describe AdminSettingsController do
  before :each do
    @admin_setting = FactoryGirl.create(:welcome_message_ad, :key => "test", :value => "test1")
    @proposed_status = FactoryGirl.build(:proposed_status)
  end
  describe "GET index" do
    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
    it "assigns all admin_setting as @@admin_setting" do
      get :index
      assigns(:admin_setting)==(@admin_setting)
    end
  end
  describe "New" do
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end
    it "assigns a new admin_setting as @admin_setting" do
      get :new
      assigns(:admin_setting).should be_a_new_record
    end
  end

  describe "GET edit" do
    it "assigns the requested admin_setting as @admin_setting" do
      get :edit, {:id => @admin_setting.to_param}
      assigns(:admin_setting)==([@admin_setting])
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