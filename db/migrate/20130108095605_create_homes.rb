class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes, :force => true do |t|

      t.timestamps
    end
  end
end
