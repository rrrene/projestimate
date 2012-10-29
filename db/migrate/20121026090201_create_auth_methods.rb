class CreateAuthMethods < ActiveRecord::Migration
  def change
    create_table :auth_methods do |t|
      t.string :name
      t.string :server_url
      t.integer :port
      t.string :base_dn
      t.string :user_name_attribute
      t.string :certificate
      t.string :scope

      t.timestamps
    end
    rename_column :users, :type_auth, :auth_type
    change_column :users, :auth_type, :integer
  end
end