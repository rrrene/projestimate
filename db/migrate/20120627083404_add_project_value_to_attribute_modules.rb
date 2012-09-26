class AddProjectValueToAttributeModules < ActiveRecord::Migration
  def change
    add_column :attribute_modules, :project_value, :string
    add_column :module_project_attributes, :project_value, :string
  end
end
