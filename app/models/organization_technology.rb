class OrganizationTechnology < ActiveRecord::Base
  attr_accessible :alias, :description, :name, :organization_id, :productivity_ratio
  belongs_to :organization
end
