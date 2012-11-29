class DeleteScope < ActiveRecord::Migration
  def change
    remove_column :auth_methods, :scope
  end
end
