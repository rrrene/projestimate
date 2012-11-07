class AddPeiconIdToWorkElementTypes < ActiveRecord::Migration
  def change
    add_column :work_element_types, :peicon_id, :integer
  end
end
