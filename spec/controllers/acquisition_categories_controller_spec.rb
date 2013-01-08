require 'spec_helper'
describe AcquisitionCategoriesController do
  before :each do
    @acquisition_category = FactoryGirl.create(:acquisition_category, :enhancement)
    @defined_status = FactoryGirl.build(:defined_status)
    @retired_status = FactoryGirl.build(:retired_status)
  end

  describe "New" do
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end
    it "assigns a new acquisition_category as @acquisition_category" do
      get :new
      assigns(:acquisition_category).should be_a_new_record
    end
  end

  describe "GET edit" do
    it "assigns the requested acquisition_category as @acquisition_category" do
      get :edit, {:id => @acquisition_category.to_param}
      assigns(:acquisition_category)==([@acquisition_category])
    end
  end

  describe "DELETE destroy" do
    #it "redirects to the acquisition_category list" do
    #  delete :destroy, {:id => @acquisition_category.to_param}
    #  #response.should redirect_to redirect(:back)
    #end
    #it "destroys the requested acquisition_category" do
    #  if @acquisition_category.record_status == @defined_status
    #    expect{ @acquisition_category.record_status == @retired_status }
    #  else
    #    expect {
    #      #delete :destroy, {:id => @acquisition_category.to_param}
    #    }.to change(AcquisitionCategory, :count).by(-1)
    #  end
    #end

  end

  describe "Create" do

  end

  describe "Update" do

  end
end