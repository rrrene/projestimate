class WbsActivity < ActiveRecord::Base
  include MasterDataHelper
  include AASM

  attr_accessible :description, :name, :organization_id, :state, :uuid

  aasm :column => :state do  # defaults to aasm_state
    state :draft, :initial => true
    state :defined
    state :retired
  end

  belongs_to :organization

end
