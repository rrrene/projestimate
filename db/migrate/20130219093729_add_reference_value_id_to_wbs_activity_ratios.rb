class AddReferenceValueIdToWbsActivityRatios < ActiveRecord::Migration
  def change
    add_column :wbs_activity_ratios, :reference_value_id, :integer
  end
end
