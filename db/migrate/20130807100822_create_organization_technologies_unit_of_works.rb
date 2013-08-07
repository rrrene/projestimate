class CreateOrganizationTechnologiesUnitOfWorks < ActiveRecord::Migration
  def change
    create_table "organization_technologies_unit_of_works", :id => false, :force => true do |t|
      t.integer  "organization_technology_id"
      t.integer  "unit_of_work_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
