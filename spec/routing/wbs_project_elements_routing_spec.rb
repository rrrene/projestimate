require "spec_helper"

describe WbsProjectElementsController do
  describe "routing" do

    it "routes to #index" do
      get("/wbs_project_elements").should route_to("wbs_project_elements#index")
    end

    it "routes to #new" do
      get("/wbs_project_elements/new").should route_to("wbs_project_elements#new")
    end

    it "routes to #show" do
      get("/wbs_project_elements/1").should route_to("wbs_project_elements#show", :id => "1")
    end

    it "routes to #edit" do
      get("/wbs_project_elements/1/edit").should route_to("wbs_project_elements#edit", :id => "1")
    end

    it "routes to #create" do
      post("/wbs_project_elements").should route_to("wbs_project_elements#create")
    end

    it "routes to #update" do
      put("/wbs_project_elements/1").should route_to("wbs_project_elements#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/wbs_project_elements/1").should route_to("wbs_project_elements#destroy", :id => "1")
    end

  end
end
