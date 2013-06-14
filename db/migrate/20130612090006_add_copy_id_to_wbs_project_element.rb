class AddCopyIdToWbsProjectElement < ActiveRecord::Migration
  def change
    add_column :wbs_project_elements, :copy_id, :integer, :after => :author_id
    add_column :module_projects, :copy_id, :integer, :after => :reference_value_id
    add_column :module_projects_pbs_project_elements, :copy_id, :integer
  end
end
