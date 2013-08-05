require 'spec_helper'

describe WorkElementTypesController do
  before :each do
    login_as_admin
  end
  describe "GET 'index'" do
    it "returns http success" do
      get "index"
      response.should render_template("index")
    end
  end

  describe "New" do
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end
  end

  describe "Edit" do
    it "renders the new template" do
      @wet = FactoryGirl.create(:work_element_type, :wet_folder)
      get :edit, {:id => @wet.id}
      response.should render_template("edit")
    end
  end

end
