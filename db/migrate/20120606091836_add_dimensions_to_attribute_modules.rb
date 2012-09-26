class AddDimensionsToAttributeModules < ActiveRecord::Migration
  def change
    add_column :attribute_modules, :dimensions, :integer
    add_column :module_project_attributes, :dimensions, :integer
  end
end
