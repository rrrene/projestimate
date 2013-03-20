class AddMasterAncestryToWbsActivityElements < ActiveRecord::Migration
  def change
    add_column :wbs_activity_elements, :master_ancestry, :string
  end
end
