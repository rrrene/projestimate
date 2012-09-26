class DeleteOldField < ActiveRecord::Migration
  def up
    remove_column :permissions, :ancestry
    remove_column :project_security_levels, :level
    remove_column :users, :is_super_admin
  end

  def down
  end
end
