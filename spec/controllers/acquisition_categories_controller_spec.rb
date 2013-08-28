require 'spec_helper'

describe AcquisitionCategoriesController do

  before :each do
    logout_admin
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability).and_return(@ability)

    @acquisition_category = FactoryGirl.create(:acquisition_category, :enhancement)
    @defined_status = FactoryGirl.build(:defined_status)
    @retired_status = FactoryGirl.build(:retired_status)
    @params = { :id => @acquisition_category.id }

  end

  describe "New" do
    it "renders the new template" do
      login_admin
      @ability.can :create, AcquisitionCategory
      get :new
      #response.should render_template("new")
      expect(:get => "/projects/new").to route_to(:controller => "projects", :action => "new")
    end

    it "assigns a new acquisition_category as @acquisition_category" do
      login_admin
      @ability.can :create, AcquisitionCategory
      get :new
      assigns(:acquisition_category).should be_a_new_record
    end
  end

  describe "GET edit" do
    it "assigns the requested acquisition_category as @acquisition_category" do
      login_admin
      @ability.can :update, AcquisitionCategory
      get :edit, {:id => @acquisition_category.to_param}
      assigns(:acquisition_category)==([@acquisition_category])
    end
  end


  describe "create" do
    it "renders the create template" do
      login_admin
      @ability.can :create, AcquisitionCategory
      acq = FactoryGirl.build(:acquisition_category, :unknown)
      @params = acq.to_param
      post :create, @params
      response.should be_success
    end

    #it "renders the create template" do
    #  @params = { :name => "Breton", :locale => "br" }
    #  post :create, @params
    #  response.should redirect_to projects_global_params_path(:anchor => "tabs-4")
    #end
  end

  describe "PUT update" do
    before :each do
      @new_ac =  FactoryGirl.create(:acquisition_category, :newDevelopment)
    end

    context "with valid params" do
      it "updates the requested acquisition_category" do
        login_admin
        @ability.can :update, AcquisitionCategory
        put :update, id: @new_ac, acquisition_category: FactoryGirl.attributes_for(:acquisition_category, :newDevelopment)
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

    it "redirects to the acquisition_category list" do
      login_admin
      @ability.can :destroy, AcquisitionCategory
      @params = { :id => @acquisition_category.id }
      delete :destroy, @params
      response.should redirect_to projects_global_params_path(:anchor => "tabs-4")
      #expect(response).to redirect_to(projects_global_params_path(:anchor => "tabs-4"))
      #expect(:delete => "/acquisition_categories/destroy").to redirect_to(:controller => "projects", :action => "projects_global_params")
    end
  end
end