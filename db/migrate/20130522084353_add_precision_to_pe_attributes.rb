class AddPrecisionToPeAttributes < ActiveRecord::Migration
  def change
    add_column :pe_attributes, :precision, :integer
  end
end
