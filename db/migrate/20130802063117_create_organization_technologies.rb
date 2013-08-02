class CreateOrganizationTechnologies < ActiveRecord::Migration
  def change
    create_table :organization_technologies do |t|
      t.integer :organization_id
      t.string :name
      t.string :alias
      t.text :description
      t.float :productivity_ratio

      t.timestamps
    end
  end
end
