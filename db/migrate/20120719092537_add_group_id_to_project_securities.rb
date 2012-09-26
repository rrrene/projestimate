class AddGroupIdToProjectSecurities < ActiveRecord::Migration
  def change
    add_column :project_securities, :group_id, :integer
  end
end
