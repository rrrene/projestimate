class RenameAttributesToPeAttributes < ActiveRecord::Migration
  def change
    rename_table :attributes, :pe_attributes

    rename_column :attribute_modules, :attribute_id, :pe_attribute_id

    rename_column :estimation_values, :attribute_id, :pe_attribute_id
  end
end
