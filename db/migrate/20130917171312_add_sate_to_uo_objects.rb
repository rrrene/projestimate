class AddSateToUoObjects < ActiveRecord::Migration
  def change
    add_column :organization_technologies, :state, :string, :limit => 20
    add_column :organization_uow_complexities, :state, :string, :limit => 20
    add_column :unit_of_works, :state, :string, :limit => 20
    add_column :subcontractors, :state, :string, :limit => 20
  end
end
