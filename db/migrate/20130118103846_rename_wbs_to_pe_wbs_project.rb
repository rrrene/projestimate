class RenameWbsToPeWbsProject < ActiveRecord::Migration
  def change
    rename_table :wbs, :pe_wbs_projects

    add_column :pe_wbs_projects, :name, :string, :after => :id

    rename_column :pbs_project_elements, :wbs_id, :pe_wbs_project_id

  end

end
