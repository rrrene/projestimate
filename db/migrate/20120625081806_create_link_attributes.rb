class CreateLinkAttributes < ActiveRecord::Migration
  def up
    create_table "links_module_project_attributes", :id => false do |t|
      t.integer  "link_id"
      t.integer  "module_project_attribute_id"
    end
  end

  def down
  end

end
