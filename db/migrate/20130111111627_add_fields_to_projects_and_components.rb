class AddFieldsToProjectsAndComponents < ActiveRecord::Migration
  def change
    add_column :projects, :copy_number, :integer

    add_column :components, :copy_id, :integer
  end
end
