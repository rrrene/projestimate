class CreateFactors < ActiveRecord::Migration
  def change
    create_table :factors do |t|
      t.string :name
      t.string :alias
      t.text :description
      t.string :state

      t.timestamps
    end
  end
end
