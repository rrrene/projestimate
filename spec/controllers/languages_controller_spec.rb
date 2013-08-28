require 'spec_helper'

describe LanguagesController do

  render_views

  before :each do
    @connected_user = login_as_admin

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability).and_return(@ability)

    ##@ability = Ability.new(@user)
    ##Ability.stub(:new).and_return(@ability)

    @language = FactoryGirl.create(:language)
    @params = { :id => @language.id }
  end


  describe "GET index" do
    before do
      group_permission_1 = mock(Permission, :object_associated => "Group", :name => "manage")
      group_permission_2 = mock(Permission, :object_associated => "Group", :name => "manage_master_groups")
      group_permission_3 = mock(Permission, :object_associated => "Language", :name => "manage")
      group_permission_4 = mock(Permission, :object_associated => "Language", :name => "create_and_edit_language")
      group_permission_5 = mock(Permission, :object_associated => "User", :name => "access_menu_admin")
      group_permission_6 = mock(Permission, :object_associated => "User", :name => "manage")

      user_groups = double(Group, :for_global_permission => true, :permissions => [group_permission_1, group_permission_2, group_permission_3, group_permission_4, group_permission_5, group_permission_6])
      user_language = double(Language, :name => "English", :locale => "en")

      @user = double(User, :language => user_language, :groups => [user_groups], :group_for_global_permissions => [user_groups])

      #@user.stub(:groups).and_return(user_groups)   ###controller.stub(:current_site).and_return(site)

      should_authorize(:index, Language)

      User.stub(:all).and_return(@user)
      Language.stub(:all).and_return(@language)

      request.cookies[:auth_token] = @user.auth_token

      controller.stub(:current_user).and_return(@user)

    end

    it "should be successful" do
      @ability.can :create_and_edit_language, Language
      get 'index'
      response.should be_success
    end

    it "renders the index template" do
      @ability.can :read, Language
      get :index
      expect(:get => "/languages").to route_to(:controller => "languages", :action => "index")
    end

    it "render index if have read ability on project" do
      @ability.can :read, Language

      get :index
      assert_template :index
  end

  end

  describe "New" do
    it "renders the new template" do
      @ability.can :create, Language
      get :new
      response.should render_template("new")
    end
  end

  describe "edit" do
    it "renders the new template" do
      @user = User.first

      @ability.can :update, Language
      get :edit, @params
      response.should render_template("edit")
    end
  end

  describe "create" do
    it "renders the create template" do
      @ability.can :create, Language

      @params = { :name => "Breton", :locale => "br" }
      post :create, @params
      response.should be_success
    end
    #it "renders the create template" do
    #  @params = { :name => "Breton", :locale => "br" }
    #  post :create, @params
    #  response.should redirect_to redirect(languages_path)
    #end
  end

  describe "PUT update" do
    before :each do
      @new_language = FactoryGirl.create(:language)
    end

    context "with valid params" do
      it "updates the requested record_status" do
        @ability.can :update, Language

        put :update, id: @new_language, language: FactoryGirl.attributes_for(:language)
        response.should be_success
      end
    end
  end

  describe "DELETE destroy" do
    #it "destroys the requested record_status" do
    #    @params = { :id => @language.id }
    #    delete :destroy, @params
    #    response.should be_success
    #end
    it "redirects to the record_statuses list" do
      login_admin
      @ability.can :destroy, Language
      @params = { :id => @language.id }

      delete :destroy, @params
      response.should redirect_to(languages_url)
      response.should be_success
    end
  end
end