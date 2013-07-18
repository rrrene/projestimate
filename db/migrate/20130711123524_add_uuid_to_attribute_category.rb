class AddUuidToAttributeCategory < ActiveRecord::Migration
  def change
    add_column :attribute_categories, :uuid, :string
    add_column :attribute_categories, :record_status_id, :integer
    add_column :attribute_categories, :custom_value, :string
    add_column :attribute_categories, :owner_id, :integer
    add_column :attribute_categories, :change_comment, :text
    add_column :attribute_categories, :reference_id, :integer
    add_column :attribute_categories, :reference_uuid, :string


  end
end
