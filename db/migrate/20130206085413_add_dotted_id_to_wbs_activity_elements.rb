class AddDottedIdToWbsActivityElements < ActiveRecord::Migration
  def change
    add_column :wbs_activity_elements, :dotted_id, :string
  end
end
