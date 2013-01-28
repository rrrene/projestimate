require 'spec_helper'

describe WorkElementTypesController do
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
      get :edit
      response.should render_template("edit")
    end
  end

end
