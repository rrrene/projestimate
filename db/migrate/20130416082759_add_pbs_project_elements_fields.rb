class AddPbsProjectElementsFields < ActiveRecord::Migration
  def change
    remove_column :module_projects_pbs_project_elements, :is_completed
    remove_column :module_projects_pbs_project_elements, :is_validated

    add_column :pbs_project_elements, :is_completed, :boolean
    add_column :pbs_project_elements, :is_validated, :boolean
  end
end
