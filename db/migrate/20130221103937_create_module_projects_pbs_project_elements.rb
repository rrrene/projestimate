class CreateModuleProjectsPbsProjectElements < ActiveRecord::Migration
  def change
    create_table "module_projects_pbs_project_elements", :id => false do |t|
      t.integer  "module_project_id"
      t.integer  "pbs_project_element_id"
    end
  end
end
