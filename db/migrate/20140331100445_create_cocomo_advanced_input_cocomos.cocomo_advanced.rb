# This migration comes from cocomo_advanced (originally 20140331095336)
class CreateCocomoAdvancedInputCocomos < ActiveRecord::Migration
  def change
    create_table :input_cocomos do |t|
      t.integer :factor_id
      t.integer :organization_uow_complexity_id
      t.integer :pbs_project_element_id
      t.integer :project_id
      t.integer :module_project_id
      t.float :coefficient

      t.timestamps
    end
  end
end
