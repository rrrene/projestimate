class AddEncryptionToAuthMethods < ActiveRecord::Migration
  def change
    add_column :auth_methods, :encryption, :string
    remove_column :auth_methods, :certificate
  end
end
