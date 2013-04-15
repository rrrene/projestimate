class AddWithActivitiesToEstimationValues < ActiveRecord::Migration
  def up
    add_column :pemodules, :with_activities, :boolean, :default => false

    change_column :estimation_values, :string_data_low, :text
    change_column :estimation_values, :string_data_most_likely, :text
    change_column :estimation_values, :string_data_high, :text
  end

  def down
    remove_column :pemodules, :with_activities

    change_column :estimation_values, :string_data_low, :string
    change_column :estimation_values, :string_data_most_likely, :string
    change_column :estimation_values, :string_data_high, :string
  end
end
