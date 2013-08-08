class CreateSubcontractors < ActiveRecord::Migration
  def change
    create_table :subcontractors do |t|
      t.integer  :organization_id
      t.string   :name
      t.string   :alias
      t.text     :description

      t.timestamps
    end
  end
end
