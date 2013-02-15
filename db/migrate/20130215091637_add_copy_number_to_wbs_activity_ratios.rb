class AddCopyNumberToWbsActivityRatios < ActiveRecord::Migration
  def change
    add_column :wbs_activity_ratios, :copy_number, :integer, :default => 0
  end
end
