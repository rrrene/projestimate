class OrganizationTechnology < ActiveRecord::Base
  include AASM

  aasm :column => :state do # defaults to aasm_state
    state :draft, :initial => true
    state :defined
    state :retired
  end

  attr_accessible :alias, :description, :name, :organization_id, :productivity_ratio, :state
  belongs_to :organization
  has_and_belongs_to_many :unit_of_works
  has_many :abacus_organizations, :dependent => :destroy

  validates :name, :alias, :presence => true, :uniqueness => {:scope => :organization_id, :case_sensitive => false}

end
