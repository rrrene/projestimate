class UpdateModuleProjects < ActiveRecord::Migration
  def up
    change_column :module_projects, :position_x, :string, :after => :project_id
    change_column :module_projects, :created_at, :string, :after => :reference_value_id
    change_column :module_projects, :updated_at, :string, :after => :created_at
  end

  def down
  end
end
