class AddMasterFieldsToWbsActivityRatiosAndWbsActivityRatioElements < ActiveRecord::Migration
  def change

      # WBS ACTIVITY RATIO
      add_column :wbs_activity_ratios, :record_status_id,  :integer
      add_column :wbs_activity_ratios, :custom_value,      :string
      add_column :wbs_activity_ratios, :owner_id,          :integer
      add_column :wbs_activity_ratios, :change_comment,    :text
      add_column :wbs_activity_ratios, :reference_id,      :integer  #Ex parent_id
      add_column :wbs_activity_ratios, :reference_uuid,    :string

      add_index :wbs_activity_ratios, :record_status_id
      add_index :wbs_activity_ratios, :owner_id
      add_index :wbs_activity_ratios, :reference_id
      add_index :wbs_activity_ratios, :uuid, :unique => true


      #WBS ACTIVITY RATIO ELEMENT
      add_column :wbs_activity_ratio_elements, :record_status_id,  :integer
      add_column :wbs_activity_ratio_elements, :custom_value,      :string
      add_column :wbs_activity_ratio_elements, :owner_id,          :integer
      add_column :wbs_activity_ratio_elements, :change_comment,    :text
      add_column :wbs_activity_ratio_elements, :reference_id,      :integer  #Ex parent_id
      add_column :wbs_activity_ratio_elements, :reference_uuid,    :string

      add_index :wbs_activity_ratio_elements, :record_status_id
      add_index :wbs_activity_ratio_elements, :owner_id
      add_index :wbs_activity_ratio_elements, :reference_id
      add_index :wbs_activity_ratio_elements, :uuid, :unique => true
    end
end
