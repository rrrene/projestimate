require 'spec_helper'

describe UsersController, 'Creating and managing user', :type => :controller do

  before do
    @connected_user = login_as_admin
  end

  describe "GET 'index'" do
    it 'returns correct template' do
      get 'index'
      response.should render_template('index')
    end
  end

  describe "GET 'edit'" do
    it 'returns correct template' do
      #@user = FactoryGirl.create(:user)
      get 'edit', :id=> @user.to_param
      response.should render_template('edit')
    end
  end

  describe "GET 'new'" do
    it 'returns correct template' do
      get 'new'
      response.should render_template('new')
    end
  end

  describe "GET 'find_use_user'" do
    it 'returns correct template' do
    #  @user = FactoryGirl.create(:user)
      @params = { :user_id => @user.id, :format => 'js' }
      get 'find_use_user', @params
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it 'returns http success' do
      get 'about'
      response.should be_success
    end
  end

  #describe "GET 'activate'" do
  #  it "returns http success" do
  #    @user = FactoryGirl.create(:user, :user_status => "active")
  #    @params = { :id => @user.id }
  #    get 'activate', @params
  #    response.should be_success
  #  end
  #end

  describe "GET 'display_states'" do
    it 'returns http success' do
      #@user = FactoryGirl.create(:user)
      @params = { :user_status => @user.user_status, :format => 'js' }
      get 'display_states', @params
      response.should be_success
    end
  end

end