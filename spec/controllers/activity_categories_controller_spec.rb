require 'spec_helper'

describe ActivityCategoriesController do

  before :each do
    @connected_user = login_as_admin
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)

    @activity_category = FactoryGirl.create(:activity_category)
    @params = { :id => @activity_category.id }
  end

  describe "GET index" do
    it "renders the index template" do
      @ability.can :read, ActivityCategory
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
      @ability.can :create, ActivityCategory
      get :new
      #response.should render_template("new")
      expect(:get => "/activity_categories/new").to route_to(:controller => "activity_categories", :action => "new")
    end

    it "assigns a new activity_category as @activity_category" do
      @ability.can :create, ActivityCategory
      get :new
      assigns(:activity_category).should be_a_new_record
    end
  end

  describe "GET edit" do
    it "assigns the requested activity_category as @activity_category" do
      @ability.can :update, ActivityCategory
      get :edit, {:id => @activity_category.to_param}
      assigns(:activity_category)==([@activity_category])
    end
  end

  describe "create" do
    #it "renders the create template" do
    #  @params = { :name => "FRench",:alias=>"test",:description=>"test", :record_status=>23, :uuid => "1", :custom_value=>"custom"  }
    #  post :create, @params
    #  response.should be_success
    #end
    #it "renders the create template" do
    #  @params = { :name => "Breton", :locale => "br" }
    #  post :create, @params
    #  response.should redirect_to projects_global_params_path(:anchor => "tabs-4")
    #end
  end

  describe "PUT update" do
    before :each do
      @new_activity_category = FactoryGirl.create(:activity_category)
    end

    context "with valid params" do
      it "updates the requested acquisition_category" do
        @ability.can :update, ActivityCategory
        #@params = { :id=> @activity_category.id,:name => "FRench",:alias=>"test",:description=>"test", :record_status=>23, :uuid => "1", :custom_value=>"custom" }
        put :update, id: @new_activity_category, activity_category: FactoryGirl.attributes_for(:activity_category)
        response.should be_success
      end
    end
  end

  describe "DELETE destroy" do
    #it "destroys the requested @acquisition_category" do
    #    @params = { :id => @acquisition_category.id }
    #    delete :destroy, @params
    #    response.should be_success
    #end
    #it "redirects to the acquisition_category list" do
    #  @params = { :id => @activity_category.id }
    #  delete :destroy, @params
    #  response.should redirect_to projects_global_params_path(:anchor => "tabs-4")
    #end
  end
end