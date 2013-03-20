class CreateAssociatedModules < ActiveRecord::Migration
  def change
    create_table "associated_module_projects", :force => true, :id => false do |t|
      t.integer  "associated_module_project_id"
      t.integer  "module_project_id"
    end
  end
end


