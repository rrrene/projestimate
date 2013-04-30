class ChangeWithActivitiesFromPemodules < ActiveRecord::Migration
  def up
    change_column :pemodules, :with_activities, :string, :after => :description
    change_column :attribute_modules, :is_mandatory, :boolean, :default => false
  end

  def down
    change_column :pemodules, :with_activities, :boolean, :after => :description
    change_column :attribute_modules, :is_mandatory, :boolean
  end
end
