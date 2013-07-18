class CreateAttributeCategories < ActiveRecord::Migration
  def change
    create_table :attribute_categories do |t|
      t.string :name
      t.string :alias

      t.timestamps
    end
  end
end
