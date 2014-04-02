# This migration comes from uos_engine (originally 20131009092730)
class CreateUos < ActiveRecord::Migration
  def self.up
    create_table :inputs, :force => true do |t|
      t.integer :module_project_id
      t.integer :technology_id
      t.integer :unit_of_work_id
      t.integer :complexity_id
      t.string  :flag
      t.string  :name
      t.integer :weight
      t.integer :size_low
      t.integer :size_most_likely
      t.integer :size_high
      t.integer :gross_low
      t.integer :gross_most_likely
      t.integer :gross_high
      t.timestamps
    end
  end

  def self.down
    drop_table :inputs
  end
end
