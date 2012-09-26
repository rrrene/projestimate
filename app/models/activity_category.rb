#Sous-découpage du domaine du projet (elle est lié à la table ProjectAreas).
class ActivityCategory < ActiveRecord::Base
  has_and_belongs_to_many :project_areas

  def to_s
    name
  end
end
