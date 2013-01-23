class WbsActivity < ActiveRecord::Base

  include AASM
  include MasterDataHelper

  #attr_accessible :description, :name, :organization_id, :state, :uuid

  aasm :column => :state do  # defaults to aasm_state
    state :draft, :initial => true
    state :defined
    state :retired
  end

  belongs_to :organization

  has_many :wbs_activity_elements, :dependent => :destroy

  #self relation on master data : Parent<->Child
  has_one    :child_reference,  :class_name => "WbsActivity", :inverse_of => :parent_reference, :foreign_key => "reference_id"
  belongs_to :parent_reference, :class_name => "WbsActivity", :inverse_of => :child_reference,  :foreign_key => "reference_id"

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true, :uniqueness => { :scope => :record_status_id, :case_sensitive => false}
  validates :custom_value, :presence => true, :if => :is_custom?
end
