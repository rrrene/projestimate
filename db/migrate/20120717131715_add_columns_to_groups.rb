class AddColumnsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :for_global_permission, :boolean
    add_column :groups, :for_project_security, :boolean
  end
end
