class AddIsRootToWbsActivityElements < ActiveRecord::Migration
  def change
    add_column :wbs_activity_elements, :is_root, :boolean
  end
end
