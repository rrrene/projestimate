class RenameRatioReferenceElementToSimpleReference < ActiveRecord::Migration
  def up
    rename_column :wbs_activity_ratio_elements, :ratio_reference_element, :simple_reference
  end

  def down
    rename_column :wbs_activity_ratio_elements, :simple_reference, :ratio_reference_element
  end
end
