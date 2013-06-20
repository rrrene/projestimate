class AddDisplayOrderToPemodules < ActiveRecord::Migration
  def change
    add_column :attribute_modules, :display_order, :integer
    add_column :estimation_values, :display_order, :integer
  end
end
