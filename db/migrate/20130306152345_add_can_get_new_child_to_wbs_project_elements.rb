class AddCanGetNewChildToWbsProjectElements < ActiveRecord::Migration
  def change
    add_column :wbs_project_elements, :can_get_new_child, :boolean
  end
end
