class AddCopyFieldsToWbsActivities < ActiveRecord::Migration
  def change
    add_column :wbs_activities, :copy_number, :integer, :default => 0

    add_column :wbs_activity_elements, :copy_id, :integer
  end
end
