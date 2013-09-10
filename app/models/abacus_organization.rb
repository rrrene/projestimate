class AbacusOrganization < ActiveRecord::Base
  attr_accessible :organization_technology_id, :organization_uow_complexity_id, :unit_or_work_id, :value, :organization_id

  belongs_to :unit_of_work
  belongs_to :organization_uow_complexity
  belongs_to :organization_technology
  belongs_to :organization
end
