class AddOrganizationIdToAbacusOrganizations < ActiveRecord::Migration
  def change
    add_column :abacus_organizations, :organization_id, :integer
  end
end
