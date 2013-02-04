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
      flash[:notice].should eq("Projestimate data have been updated successfully.")
      flash[:error].should be_nil
    end
  end

end
