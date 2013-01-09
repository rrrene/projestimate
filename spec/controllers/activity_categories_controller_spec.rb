require 'spec_helper'
describe ActivityCategoriesController do
  before :each do
    @activity_category = FactoryGirl.create(:activity_category)
  end
  describe "GET index" do
    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
    it "assigns all activity_category as @activity_category" do
      get :index
      assigns(:activity_category)==(@activity_category)
    end
  end
  describe "New" do
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end
    it "assigns a new activity_category as @activity_category" do
      get :new
      assigns(:activity_category).should be_a_new_record
    end
  end

  describe "GET edit" do
    it "assigns the requested activity_category as @activity_category" do
      get :edit, {:id => @activity_category.to_param}
      assigns(:activity_category)==([@activity_category])
    end
  end

  describe "DELETE destroy" do
    #it "redirects to the activity_category list" do
    #  delete :destroy, {:id => :activity_category.to_param}
    #  response.should redirect_to(activity_categories_url)
    #end
    #it "destroys the requested activity_category" do
    #  expect {
    #    delete :destroy, {:id => :activity_category.to_param}
    #  }.to change(ActivityCategory, :count).by(-1)
    #end

  end
end