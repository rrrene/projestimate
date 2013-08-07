require 'spec_helper'
describe PemodulesController do

  before do
    @connected_user = login_as_admin
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
  end

  describe "GET index" do
    it "renders the index template" do
      @ability.can :read, Pemodule
      get :index
      response.should render_template("index")
    end
  end

  describe "New" do
    it "renders the new template" do
      @ability.can :create, Pemodule

      get :new
      response.should render_template("new")
    end
  end

end