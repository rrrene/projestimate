class RenameComponentToPbsProjectElement < ActiveRecord::Migration

  def change
    rename_table :pbs_project_elements, :pbs_project_elements

    rename_column :module_project_attributes, :component_id, :pbs_project_element_id
  end
end
