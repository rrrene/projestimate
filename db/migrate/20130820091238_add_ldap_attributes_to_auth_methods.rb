class AddLdapAttributesToAuthMethods < ActiveRecord::Migration
  def change
    add_column :auth_methods, :on_the_fly_user_creation, :boolean,       :default => false
    add_column :auth_methods, :ldap_bind_dn, :string
    add_column :auth_methods, :ldap_bind_encrypted_password , :string
    add_column :auth_methods, :ldap_bind_salt , :string
    add_column :auth_methods, :priority_order, :integer,      :default => 1
    add_column :auth_methods, :first_name_attribute, :string
    add_column :auth_methods, :last_name_attribute, :string
    add_column :auth_methods, :email_attribute, :string
    add_column :auth_methods, :initials_attribute, :string
  end
end
