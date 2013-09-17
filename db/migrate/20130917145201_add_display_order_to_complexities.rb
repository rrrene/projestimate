class AddDisplayOrderToComplexities < ActiveRecord::Migration
  def change
    add_column :organization_uow_complexities, :display_order, :integer
  end
end
