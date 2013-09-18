class AddNameToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :alias, :string
    add_column :permissions, :is_master_permission, :boolean
    add_column :permissions, :category, :string , :default => "Admin"
  end
end
