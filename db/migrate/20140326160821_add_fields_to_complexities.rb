class AddFieldsToComplexities < ActiveRecord::Migration
  def change
    add_column :organization_uow_complexities, :factor_id, :integer
    add_column :organization_uow_complexities, :unit_of_work_id, :integer
  end
end
