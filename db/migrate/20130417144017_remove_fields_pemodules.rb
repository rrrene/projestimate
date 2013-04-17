class RemoveFieldsPemodules < ActiveRecord::Migration

  def self.up
    remove_column :estimation_values, :numeric_data_low
    remove_column :estimation_values, :numeric_data_most_likely
    remove_column :estimation_values, :numeric_data_high

    remove_column :estimation_values, :date_data_low
    remove_column :estimation_values, :date_data_most_likely
    remove_column :estimation_values, :date_data_high

    remove_column :attribute_modules, :date_data_low
    remove_column :attribute_modules, :date_data_most_likely
    remove_column :attribute_modules, :date_data_high

    remove_column :attribute_modules, :numeric_data_low
    remove_column :attribute_modules, :numeric_data_most_likely
    remove_column :attribute_modules, :numeric_data_high

    rename_column :attribute_modules, :string_data_low, :default_low
    rename_column :attribute_modules, :string_data_most_likely, :default_most_likely
    rename_column :attribute_modules, :string_data_high, :default_high
  end

  def self.down
    add_column :estimation_values, :numeric_data_low, :float
    add_column :estimation_values, :numeric_data_most_likely, :float
    add_column :estimation_values, :numeric_data_high, :float

    add_column :estimation_values, :date_data_low, :date
    add_column :estimation_values, :date_data_most_likely, :date
    add_column :estimation_values, :date_data_high, :date

    add_column :attribute_modules, :date_data_low, :date
    add_column :attribute_modules, :date_data_most_likely, :date
    add_column :attribute_modules, :date_data_high, :date

    add_column :attribute_modules, :numeric_data_low, :float
    add_column :attribute_modules, :numeric_data_most_likely, :float
    add_column :attribute_modules, :numeric_data_high, :float

    rename_column :attribute_modules, :default_low, :string_data_low
    rename_column :attribute_modules, :default_most_likely, :string_data_most_likely
    rename_column :attribute_modules, :default_high, :string_data_high
  end

end
