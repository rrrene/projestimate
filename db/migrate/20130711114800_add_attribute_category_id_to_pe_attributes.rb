class AddAttributeCategoryIdToPeAttributes < ActiveRecord::Migration
  def change
    add_column :pe_attributes, :attribute_category_id, :integer
  end
end
