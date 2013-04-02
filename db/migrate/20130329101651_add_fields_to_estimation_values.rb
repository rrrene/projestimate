class AddFieldsToEstimationValues < ActiveRecord::Migration
  def change
    add_column :estimation_values, :wbs_project_element_id, :integer
    add_column :estimation_values, :string_data_probable, :string
    add_column :estimation_values, :numeric_data_probable, :float
    add_column :estimation_values, :date_data_probable, :date
  end
end
