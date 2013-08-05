require 'spec_helper'
describe ModuleProjectsController do

  before :each do
    login_as_admin
  end

  describe "GET index" do
    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end
  describe "New" do
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end
  end

end