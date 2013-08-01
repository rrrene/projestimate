class AddDescriptionToProjectSecurityLevels < ActiveRecord::Migration
  def change
    add_column :project_security_levels, :description, :text
  end
end
