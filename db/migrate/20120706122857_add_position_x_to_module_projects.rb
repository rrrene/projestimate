class AddPositionXToModuleProjects < ActiveRecord::Migration
  def change
    add_column :module_projects, :position_x, :integer
    rename_column :module_projects, :position, :position_y
  end
end
