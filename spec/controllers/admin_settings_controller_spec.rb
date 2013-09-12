require 'spec_helper'

describe AdminSettingsController do

  before :each do
    @user = login_as_admin

    @admin_setting = FactoryGirl.create(:welcome_message_ad, :key => 'test', :value => 'test1')
    @proposed_status = FactoryGirl.build(:proposed_status)
    @params = { :id => @admin_setting.id }
  end

  describe 'GET index' do
    it 'renders the index template' do
      @ability.can :read, AdminSetting
      get :index
      response.should render_template('index')
    end

    it 'assigns all admin_setting as @@admin_setting' do
      @ability.can :read, AdminSetting
      get :index
      assigns(:admin_setting)==(@admin_setting)
    end
  end

  describe 'New' do
    it 'renders the new template' do
      @ability.can :create, AdminSetting
      get :new
      response.should render_template('new')
    end

    it 'assigns a new admin_setting as @admin_setting' do
      get :new
      assigns(:admin_setting).should be_a_new_record
    end
  end

  describe 'GET edit' do
    it 'assigns the requested admin_setting as @admin_setting' do
      get :edit, {:id => @admin_setting.to_param}
      assigns(:admin_setting)==([@admin_setting])
    end
  end

  describe 'create' do
    it 'renders the create template' do
      @ability.can :create, AdminSetting

      @params = {:record_status_id=>2, :value=> 'Welcome',:uuid=>2,:key=> 'welcome_message',:custom_value=> 'local'}
      post :create, @params
      response.should be_success
    end
    #it "renders the create template" do
    #  @params = {:record_status_id=>2, :value=>"Welcome",:uuid=>2,:key=>"welcome_message",:custom_value=>"local" }
    #  post :create, @params
    #  response.should redirect_to(admin_settings_path)
    #end
  end

  describe 'PUT update' do
    before :each do
      @my_admin_setting = FactoryGirl.create(:admin_setting, :welcome_message)
    end

    context 'with valid params' do
      it 'located the requested @admin_setting' do

      end

      it 'updates the requested @admin_setting and redirect to the updated admin_setting' do
        @ability.can :update, AdminSetting

        put :update, id: @my_admin_setting, admin_setting: FactoryGirl.attributes_for(:admin_setting, :welcome_message)
        response.should be_success
      end
    end
  end

  describe 'DELETE destroy' do
    #it "destroys the requested @admin_setting" do
    #    @params = { :id => @admin_setting.id }
    #    delete :destroy, @params
    #    response.should be_success
    #end

    it 'redirects to the @admin_setting list' do
      @ability.can :destroy, AdminSetting

      @params = { :id => @admin_setting.id }
      delete :destroy, @params
      response.should redirect_to (admin_settings_path)
    end
  end
end