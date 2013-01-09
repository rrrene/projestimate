require 'spec_helper'
describe AttributesController do
  before :each do
    @attribute = FactoryGirl.create(:ksloc_attribute)
  end

  describe "GET index" do
    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
    it "assigns all attributes as @attributes" do
      get :index
      assigns(:ksloc_attribute)==(@attribute)
    end
  end
  describe "New" do
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end
    #it "assigns a new attributes as @attribute" do
    #  get :new
    #  assigns(:ksloc_attribute).should be_a_new_record
    #end
  end

  describe "GET edit" do
    it "assigns the requested attribute as @attribute" do
      get :edit, {:id => @attribute.to_param}
      assigns(:ksloc_attribute)==(@attribute)
    end
  end
  describe "PUT update" do
  end

  describe "POST create" do
  end

  describe "DELETE destroy" do

    it "redirects to the attributes list" do
      delete :destroy, {:id => @attribute.to_param}
      response.should redirect_to(attributes_url)
    end
    it "destroys the requested event" do
      expect {
        delete :destroy, {:id => @attribute.to_param}
      }.to change(Attribute, :count).by(-1)
    end
  end

end