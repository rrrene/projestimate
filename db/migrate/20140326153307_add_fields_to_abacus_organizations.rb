class AddFieldsToAbacusOrganizations < ActiveRecord::Migration
  def change
    add_column :abacus_organizations, :factor_id, :integer
  end
end
