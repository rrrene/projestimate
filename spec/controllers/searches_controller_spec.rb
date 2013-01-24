require 'spec_helper'
  describe SearchesController do

    describe "GET results" do
      it "renders the results template" do
        @params = { :search => "sample" }
        post :results, @params
        response.should render_template("results")
      end
    end

    describe "user_search" do
      it "renders the user_search template" do
        @params = { :states => "", :user_searches => "admin", :page => 1, :format => 'js' }
        get :user_search, @params
        response.should be_success
      end
    end

    describe "project_search" do
      it "renders the project_search template" do
        @params = { :project_searches => "sample", :page => 1, :format => 'js' }
        get :project_search, @params
        response.should be_success
      end
    end

  end