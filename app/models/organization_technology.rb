class OrganizationTechnology < ActiveRecord::Base
  attr_accessible :alias, :description, :name, :organization_id, :productivity_ratio
  belongs_to :organization
  has_and_belongs_to_many :unit_of_works

end
