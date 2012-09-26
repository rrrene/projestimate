#Sous-découpage du domaine du projet (elle est lié à la table ProjectAreas).
class LaborCategory < ActiveRecord::Base
  has_many :projects
  has_many :organization_labor_categories
end
