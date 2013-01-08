require 'spec_helper'
describe PermissionsController do

  describe "GET index" do
    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end
end