class AddIsAddedWbsRootToWbsProjectElements < ActiveRecord::Migration
  def change
    add_column :wbs_project_elements, :is_added_wbs_root, :boolean
  end
end
