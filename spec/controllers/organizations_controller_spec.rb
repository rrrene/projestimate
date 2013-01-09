require 'spec_helper'
describe OrganizationsController do

  describe "New" do
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end
  end

end