class CreateWbsActivityRatioElements < ActiveRecord::Migration
  def change
    create_table :wbs_activity_ratio_elements, :force => true do |t|
      t.string :uuid
      t.integer :wbs_activity_ratio_id
      t.integer :wbs_activity_element_id
      t.float :ratio_value
      t.boolean :ratio_reference_element

      t.timestamps
    end
  end
end
