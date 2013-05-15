class UpdatePositionX < ActiveRecord::Migration
  def up
    change_column :module_projects, :position_x, :integer
  end

  def down
  end
end
