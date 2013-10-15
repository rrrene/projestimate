class UpdatedVersionFromProjects < ActiveRecord::Migration
  def change
    change_column :projects, :version, "char(64)"
  end
end
