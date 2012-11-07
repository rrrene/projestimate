class CreatePeicons < ActiveRecord::Migration
  def change
    create_table :peicons do |t|
      t.string :name

      t.timestamps
    end
  end
end
