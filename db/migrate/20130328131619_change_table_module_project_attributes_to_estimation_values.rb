class ChangeTableModuleProjectAttributesToEstimationValues < ActiveRecord::Migration
  def change
     rename_table :module_project_attributes, :estimation_values
   end
end
