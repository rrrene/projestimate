#Sous-découpage du domaine du projet (elle est lié à la table ProjectAreas).
class OrganizationLaborCategory < ActiveRecord::Base
  belongs_to :labor_category
  belongs_to :currency

end
