class CreateOrganizationUowComplexities < ActiveRecord::Migration
  def change
    create_table :organization_uow_complexities, :force => true do |t|
      t.integer :organization_id
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
