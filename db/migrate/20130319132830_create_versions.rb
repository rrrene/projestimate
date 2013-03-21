class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions, :force => true do |t|
      t.datetime :local_latest_update
      t.datetime :repository_latest_update
      t.text :comment

      t.timestamps
    end

    Version.create :comment => "No update data has been save"
  end
end
