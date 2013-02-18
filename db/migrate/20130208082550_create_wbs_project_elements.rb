class CreateWbsProjectElements < ActiveRecord::Migration
  def change
    create_table :wbs_project_elements, :force => true do |t|
      t.integer :pe_wbs_project_id
      t.integer :wbs_activity_element_id
      t.integer :wbs_activity_id
      t.string :name
      t.text :description
      t.text :additional_description
      t.boolean :exclude, :default => false
      t.string :ancestry
      t.integer :author_id
      t.integer :copy_number, :default => 0

      t.timestamps
    end
  end
end
