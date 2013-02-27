class AddMasterFieldsToReferenceValues < ActiveRecord::Migration
  def change
      #WBS ACTIVITY RATIO ELEMENT
      add_column :reference_values, :record_status_id,  :integer
      add_column :reference_values, :custom_value,      :string
      add_column :reference_values, :owner_id,          :integer
      add_column :reference_values, :change_comment,    :text
      add_column :reference_values, :reference_id,      :integer
      add_column :reference_values, :reference_uuid,    :string
      add_column :reference_values, :uuid,    :string

      add_index :reference_values, :record_status_id
      add_index :reference_values, :owner_id
      add_index :reference_values, :reference_id
      add_index :reference_values, :uuid, :unique => true
  end
end
