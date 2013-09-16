class UpdateVersionAncestryFromProjects < ActiveRecord::Migration
  def change
    change_column :projects, :version_ancestry, :string, :after => :alias
    rename_column :projects, :version_ancestry, :ancestry

    add_index :projects, :ancestry
  end
end
