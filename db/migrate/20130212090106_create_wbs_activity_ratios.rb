class CreateWbsActivityRatios < ActiveRecord::Migration
  def change
    create_table :wbs_activity_ratios, :force => true do |t|
      t.string :uuid
      t.string :name
      t.text :description
      t.integer :wbs_activity_id

      t.timestamps
    end
  end
end
