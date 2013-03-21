class CreateEjEstimationValues < ActiveRecord::Migration
  def change
    create_table :ej_estimation_values do |t|
      t.integer :project_id
      t.integer :pbs_project_element_id
      t.integer :wbs_activity_element_id
      t.float :minimum
      t.float :most_likely
      t.float :maximum
      t.float :probable

      t.timestamps
    end
  end
end
