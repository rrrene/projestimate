class AddMasterFieldsToWbsActivities < ActiveRecord::Migration
  def change

    # WBS ACTIVITY
    add_column :wbs_activities, :record_status_id,  :integer
    add_column :wbs_activities, :custom_value,      :string
    add_column :wbs_activities, :owner_id,          :integer
    add_column :wbs_activities, :change_comment,    :text
    add_column :wbs_activities, :reference_id,      :integer  #Ex parent_id
    add_column :wbs_activities, :reference_uuid,    :string

    add_index :wbs_activities, :record_status_id
    add_index :wbs_activities, :owner_id
    add_index :wbs_activities, :reference_id
    add_index :wbs_activities, :uuid, :unique => true


    # WBS ACTIVITY ELEMENT
    add_column :wbs_activity_elements, :record_status_id,  :integer
    add_column :wbs_activity_elements, :custom_value,      :string
    add_column :wbs_activity_elements, :owner_id,          :integer
    add_column :wbs_activity_elements, :change_comment,    :text
    add_column :wbs_activity_elements, :reference_id,      :integer  #Ex parent_id
    add_column :wbs_activity_elements, :reference_uuid,    :string

    add_index :wbs_activity_elements, :record_status_id
    add_index :wbs_activity_elements, :owner_id
    add_index :wbs_activity_elements, :reference_id
    add_index :wbs_activity_elements, :uuid, :unique => true
  end
end
