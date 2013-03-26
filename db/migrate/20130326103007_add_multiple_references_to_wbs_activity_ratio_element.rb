class AddMultipleReferencesToWbsActivityRatioElement < ActiveRecord::Migration
  def change
    add_column :wbs_activity_ratio_elements, :multiple_references, :boolean
  end
end
