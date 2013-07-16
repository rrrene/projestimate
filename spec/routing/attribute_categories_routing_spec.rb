require "spec_helper"

describe AttributeCategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/attribute_categories").should route_to("attribute_categories#index")
    end

    it "routes to #new" do
      get("/attribute_categories/new").should route_to("attribute_categories#new")
    end

    it "routes to #show" do
      get("/attribute_categories/1").should route_to("attribute_categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/attribute_categories/1/edit").should route_to("attribute_categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/attribute_categories").should route_to("attribute_categories#create")
    end

    it "routes to #update" do
      put("/attribute_categories/1").should route_to("attribute_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/attribute_categories/1").should route_to("attribute_categories#destroy", :id => "1")
    end

  end
end
