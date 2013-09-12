require 'spec_helper'

describe OrganizationsController do

  before do
    @connected_user = login_as_admin
  end

  describe 'New' do
    it 'renders the new template' do
      #@ability.can :create, Organization
      get :new
      response.should render_template('new')
    end
  end

end