require 'spec_helper'

describe HomesController do

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'update_install'" do
    it "returns http success" do
      get 'update_install'
      response.should be_success
    end
  end

end
