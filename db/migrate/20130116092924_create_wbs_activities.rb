class CreateWbsActivities < ActiveRecord::Migration
  def change
    create_table :wbs_activities do |t|
      t.string :uuid
      t.string :name
      t.string :state
      t.text :description
      t.integer :organization_id

      t.timestamps
    end
  end
end
