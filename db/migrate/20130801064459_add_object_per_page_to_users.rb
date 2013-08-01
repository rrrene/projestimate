class AddObjectPerPageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :object_per_page, :integer
  end
end