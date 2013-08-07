class CreateUnitOfWorks < ActiveRecord::Migration
  def change
    create_table :unit_of_works do |t|
      t.integer :organization_id
      t.string :name
      t.string :alias
      t.text :description

      t.timestamps
    end
  end
end
