class Subcontractor < ActiveRecord::Base
  include AASM

  aasm :column => :state do # defaults to aasm_state
    state :draft, :initial => true
    state :defined
    state :retired
  end

  attr_accessible :description, :name, :organization_id, :alias, :state

  belongs_to :organization

  validates :name, :alias, :presence => true, :uniqueness => {:scope => :organization_id, :case_sensitive => false}
end
