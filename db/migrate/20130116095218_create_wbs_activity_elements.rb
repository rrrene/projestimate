class CreateWbsActivityElements < ActiveRecord::Migration
  def change
    create_table :wbs_activity_elements, :force => true do |t|
      t.string :uuid
      t.integer :wbs_activity_id
      t.string :name
      t.text :description
      t.string :ancestry

      t.timestamps
    end

    add_index :wbs_activity_elements, :wbs_activity_id
    add_index :wbs_activity_elements, :ancestry
  end
end
