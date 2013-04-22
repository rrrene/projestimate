require 'spec_helper'
describe PeAttributesController do
  before :each do
    @attribute = FactoryGirl.create(:ksloc_attribute)
    @params = { :id => @attribute.id }
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

  describe "create" do
    #it "renders the create template" do
    #  @params = { :name => "KSLOC1",:allias=>"KSLOC1", :uuid => "1", :description=>"test", :attr_type=>"integer", :record_status=>23, :custom_value=>"local"}
    #  post :create, @params
    #  response.should be_success
    #end
    #it "renders the create template" do
    #  @params = { :name => "KSLOC1",:allias=>"KSLOC1", :uuid => "1", :description=>"test", :attr_type=>"integer", :record_status=>23, :custom_value=>"local"}
    #  post :create, @params
    #  response.should redirect_to redirect(attributes_path)
    #end
  end

  describe "PUT update" do
    before :each do
      @new_attribute = FactoryGirl.create(:cost_attribute)
    end

    context "with valid params" do
      it "updates the requested acquisition_category" do
        @params = { :id=> @attribute.id,:name => "KSLOC1",:allias=>"KSLOC1", :uuid => "1", :description=>"test", :attr_type=>"integer", :record_status => RecordStatus.first.id, :custom_value=>"local" }
        put :update, id: @new_attribute, attribute: FactoryGirl.attributes_for(:cost_attribute)
        response.should be_success
      end
    end
  end

  describe "DELETE destroy" do

    it "redirects to the attributes list" do
      delete :destroy, {:id => @attribute.to_param}
      response.should redirect_to(pe_attributes_url)
    end
    it "destroys the requested event" do
      expect {
        delete :destroy, {:id => @attribute.to_param}
      }.to change(PeAttribute, :count).by(-1)
    end
  end

end