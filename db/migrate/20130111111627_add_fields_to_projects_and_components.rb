class AddFieldsToProjectsAndComponents < ActiveRecord::Migration
  def change
    add_column :projects, :copy_number, :integer

    add_column :pbs_project_elements, :copy_id, :integer
  end
end
