class RenameUserFields < ActiveRecord::Migration
  def change
    rename_column :users, :surename, :last_name
    rename_column :users, :user_name, :login_name
  end
end
