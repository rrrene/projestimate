class CreateReferenceValues < ActiveRecord::Migration
  def change
    create_table :reference_values, :force => true do |t|
      t.string :value
      t.timestamps
    end
  end
end
