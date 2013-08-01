require 'spec_helper'

describe WorkElementTypesController do

  before do
    @connected_user = login_as_admin
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
  end

  describe "GET 'index'" do
    it "returns http success" do
      @ability.can :read, WorkElementType
      get "index"
      response.should render_template("index")
    end
  end

  describe "New" do
    it "renders the new template" do
      @ability.can :read, WorkElementType
      get :new
      response.should render_template("new")
    end
  end

  describe "Edit" do
    it "renders the new template" do
      @ability.can :update, WorkElementType
      @wet = FactoryGirl.create(:work_element_type, :wet_folder)
      get :edit, {:id => @wet.id}
      response.should render_template("edit")
    end
  end

end
