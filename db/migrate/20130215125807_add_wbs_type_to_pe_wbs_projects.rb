class AddWbsTypeToPeWbsProjects < ActiveRecord::Migration
  def change
    add_column :pe_wbs_projects, :wbs_type, :string
  end
end
