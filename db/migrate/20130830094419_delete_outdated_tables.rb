class DeleteOutdatedTables < ActiveRecord::Migration
  def up
    remove_index "activity_categories", :name => "index_activity_categories_on_record_status_id"
    remove_index "activity_categories", :name => "index_activity_categories_on_parent_id"
    remove_index "activity_categories", :name => "index_activity_categories_on_uuid"

    drop_table :activity_categories
    drop_table :activity_categories_project_areas
    drop_table :project_staffs
    drop_table :reference_values
    drop_table :roles_users
    drop_table :links_module_project_attributes
    drop_table :helps
    drop_table :help_types
    drop_table :homes
    drop_table :results

    remove_column :module_projects, :reference_value_id
    remove_column :projects_users, :settings

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
