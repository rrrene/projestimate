class CreateAttributeOrganizations0 < ActiveRecord::Migration
  def change
    create_table :attribute_organizations do |t|
      t.integer :pe_attribute_id
      t.integer :organization_id
      t.boolean :is_mandatory

      t.timestamps
    end
  end
end
