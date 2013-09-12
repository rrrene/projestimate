require 'spec_helper'

describe WbsActivitiesController do

  before do
    @connected_user = login_as_admin
  end

  describe "GET 'index'" do
    it 'returns http success' do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it 'returns http success' do
      @wbs_activity = FactoryGirl.create(:wbs_activity)
      get 'edit', {:id => @wbs_activity.id}
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it 'returns http success' do
      get 'new'
      response.should be_success
    end
  end

end
