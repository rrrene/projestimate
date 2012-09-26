class AddAncestryToModuleProjectAttribute < ActiveRecord::Migration
  def self.up
    add_column :module_project_attributes, :ancestry, :string
    add_index :module_project_attributes, :ancestry
  end

  def self.down
    remove_column :module_project_attributes, :ancestry
    remove_index :module_project_attributes, :ancestry
  end
end
