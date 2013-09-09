class UpdateFieldsTypeFromUsers < ActiveRecord::Migration
  def change
    change_column :users, :last_login, :datetime
    change_column :users, :previous_login, :datetime
  end
end
