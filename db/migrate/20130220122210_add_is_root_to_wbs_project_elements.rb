class AddIsRootToWbsProjectElements < ActiveRecord::Migration
  def change
    add_column :wbs_project_elements, :is_root, :boolean
  end
end
