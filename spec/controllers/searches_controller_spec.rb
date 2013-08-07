require 'spec_helper'
  describe SearchesController do
    before :each do
      login_as_admin
    end
    describe "GET results" do
      it "renders the results template" do
        @params = { :search => "sample" }
        post :results, @params
        response.should render_template("results")
      end
    end

  end