class AddFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :version, :string
    add_column :projects, :version_ancestry, :integer
    add_column :projects, :master_anscestry, :integer
    add_column :projects, :owner, :integer
    add_column :projects, :purpose, :text
    add_column :projects, :level_of_detail, :text
    add_column :projects, :scope, :text
  end
end
