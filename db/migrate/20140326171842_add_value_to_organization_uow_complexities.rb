class AddValueToOrganizationUowComplexities < ActiveRecord::Migration
  def change
    add_column :organization_uow_complexities, :value, :float
  end
end
