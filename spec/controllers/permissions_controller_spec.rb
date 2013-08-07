require 'spec_helper'
describe PermissionsController do

  before do
    @connected_user = login_as_admin
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
  end

  describe "GET index" do
    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end
end