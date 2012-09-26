#Sous-découpage du domaine du projet (elle est lié à la table ProjectAreas).
class PlatformCategory < ActiveRecord::Base
  has_many :projects
  has_and_belongs_to_many :project_areas

  searchable do
    text :name, :description
  end

  #Override
  def to_s
    self.name
  end
end
