class AddIsLockedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :is_locked, :boolean
  end
end
