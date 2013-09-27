class RenameOwnerToCreatorIdFormProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :owner, :creator_id
  end
end
