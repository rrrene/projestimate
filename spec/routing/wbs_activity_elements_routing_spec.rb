require "spec_helper"

describe WbsActivityElementsController do
  describe "routing" do

    it "routes to #index" do
      get("/wbs_activity_elements").should route_to("wbs_activity_elements#index")
    end

    it "routes to #new" do
      get("/wbs_activity_elements/new").should route_to("wbs_activity_elements#new")
    end

    it "routes to #show" do
      get("/wbs_activity_elements/1").should route_to("wbs_activity_elements#show", :id => "1")
    end

    it "routes to #edit" do
      get("/wbs_activity_elements/1/edit").should route_to("wbs_activity_elements#edit", :id => "1")
    end

    it "routes to #create" do
      post("/wbs_activity_elements").should route_to("wbs_activity_elements#create")
    end

    it "routes to #update" do
      put("/wbs_activity_elements/1").should route_to("wbs_activity_elements#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/wbs_activity_elements/1").should route_to("wbs_activity_elements#destroy", :id => "1")
    end

  end
end
