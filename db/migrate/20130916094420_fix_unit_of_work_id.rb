class FixUnitOfWorkId < ActiveRecord::Migration
  def change
    rename_column :abacus_organizations, :unit_or_work_id, :unit_of_work_id
  end
end