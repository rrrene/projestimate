#Sous-découpage du domaine du projet (elle est lié à la table ProjectAreas).
#Pour le logiciel c’est le type d’application … Cf.
#Application dans SEER (SEM et H), Application type dans ISBCG.
class ProjectCategory < ActiveRecord::Base
  has_many :projects
  has_and_belongs_to_many :project_areas

  #Sunspot needs
  searchable do
    text :name, :description
  end

  #Override
  def to_s
    self.name
  end
end
