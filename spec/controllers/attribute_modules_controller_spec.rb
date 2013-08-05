require 'spec_helper'
describe AttributeModulesController do

  before do
    @connected_user = login_as_admin
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
  end

  before :each do
  end


  describe "create" do

  end

  describe "DELETE destroy" do

  end
end