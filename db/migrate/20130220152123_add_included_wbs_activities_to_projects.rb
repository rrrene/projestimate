class AddIncludedWbsActivitiesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :included_wbs_activities, :text
  end
end
