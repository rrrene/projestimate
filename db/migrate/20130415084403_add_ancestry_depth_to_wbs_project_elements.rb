class AddAncestryDepthToWbsProjectElements < ActiveRecord::Migration
  def change
    add_column :wbs_project_elements, :ancestry_depth, :integer, :default => 0, :after => :ancestry
  end
end
