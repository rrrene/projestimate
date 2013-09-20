class PopulateAliasPermissions < ActiveRecord::Migration
  def change
    Permission.all.each do |permission|
      permission.update_attributes({ :alias => permission.name })
    end
  end
end
