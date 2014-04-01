class CreateAbacusOrganizations < ActiveRecord::Migration
  def change
    create_table :abacus_organizations, :force => true do |t|
      t.float :value
      t.integer :unit_or_work_id
      t.integer :organization_uow_complexity_id
      t.integer :organization_technology_id

      t.timestamps
    end
  end
end
