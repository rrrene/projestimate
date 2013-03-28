class AddDefaultRatioToPeWbsProjectsAndPbs < ActiveRecord::Migration
  def change
    add_column :wbs_project_elements, :wbs_activity_ratio_id, :integer      #Project default Wbs Activity Ratio

    add_column :pbs_project_elements, :wbs_activity_id,       :integer
    add_column :pbs_project_elements, :wbs_activity_ratio_id, :integer #Pbs default Wbs Activity Ratio

    add_column :module_projects, :reference_value_id, :integer
  end
end
