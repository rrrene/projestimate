class DropProjectCategoriesProjectAreas < ActiveRecord::Migration
  def up
    drop_table :project_categories_project_areas
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
