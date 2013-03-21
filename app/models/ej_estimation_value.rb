class EjEstimationValue < ActiveRecord::Base
  attr_accessible :maximum, :minimum, :most_likely, :pbs_project_element_id, :probable, :project_id, :wbs_activity_element_id

  belongs_to :project
  belongs_to :pbs_project_element
  belongs_to :wbs_activity_element

end
