class ChangeFieldsEstimationValues < ActiveRecord::Migration
  def up
    change_column :estimation_values, :string_data_probable, :text, :after => :string_data_high
    change_column :estimation_values, :date_data_probable, :date, :after => :string_data_probable
    change_column :estimation_values, :module_project_id, :integer, :after => :id

    remove_column :estimation_values, :numeric_data_probable
    remove_column :estimation_values, :undefined_attribute
    remove_column :estimation_values, :pbs_project_element_id
    remove_column :estimation_values, :dimensions
    remove_column :estimation_values, :wbs_project_element_id
    remove_column :estimation_values, :ancestry
  end

  def down
  end
end
