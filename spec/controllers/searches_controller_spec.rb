require 'spec_helper'
  describe SearchesController do

    describe "GET results" do
      it "renders the results template" do
        @params = { :search => "sample" }
        post :results, @params
        response.should render_template("results")
      end
    end

  end