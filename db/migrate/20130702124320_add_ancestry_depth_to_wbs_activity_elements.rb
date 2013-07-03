class AddAncestryDepthToWbsActivityElements < ActiveRecord::Migration
  def change
    add_column :wbs_activity_elements, :ancestry_depth, :integer, :default => 0, :after => :ancestry
  end
end
