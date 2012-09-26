class ChangeCustomAttribute < ActiveRecord::Migration
  def up
    remove_column :attribute_modules, :custom_attribute
    remove_column :module_project_attributes, :custom_attribute

    add_column :attribute_modules, :custom_attribute, :string
    add_column :module_project_attributes, :custom_attribute, :string
  end

  def down
  end
end
