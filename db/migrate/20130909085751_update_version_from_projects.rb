class UpdateVersionFromProjects < ActiveRecord::Migration
  def change
    change_column :projects, :version, :string, :after => :title, :default => "1.0"
    change_column :projects, :description, :text, :after => :alias
  end
end
