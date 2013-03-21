class AddEstimationFieldsToModuleProjectsPbsProjectElements < ActiveRecord::Migration

  def change
    add_column :module_projects_pbs_project_elements, :is_completed, :boolean
    add_column :module_projects_pbs_project_elements, :is_validated, :boolean
  end
end
