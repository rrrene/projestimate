class RemoveReferenceValueIdToWbsActivityRatios < ActiveRecord::Migration
  def up
    remove_column :wbs_activity_ratios, :reference_value_id
  end

  def down
    add_column :wbs_activity_ratios, :reference_value_id, :integer
  end
end
