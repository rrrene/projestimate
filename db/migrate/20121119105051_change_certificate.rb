class ChangeCertificate < ActiveRecord::Migration
  def change
    change_column :auth_methods, :certificate, :boolean
  end
end
