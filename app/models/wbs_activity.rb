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

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true, :uniqueness => { :scope => :record_status_id, :case_sensitive => false}
  validates :custom_value, :presence => true, :if => :is_custom?

  #accepts_nested_attributes_for :wbs_activity_elements, :allow_destroy => true
  #validate :must_have_children
  #def must_have_children
  #  #if wbs_activity_elements.empty? or wbs_activity_elements.all? {|child| child.marked_for_destruction? }
  #    errors.add(:base, 'Must have at least one wbs-activity-element')  if wbs_activity_elements.all?(&:marked_for_destruction?)
  #  #end
  #end


  #Enable the amoeba gem for deep copy/clone (dup with associations)
  amoeba do
    enable
    include_field [:wbs_activity_elements]

    customize(lambda { |original_wbs_activity, new_wbs_activity|

      new_wbs_activity.name = "Copy_#{ original_wbs_activity.copy_number.to_i+1} of #{original_wbs_activity.name}"

      new_wbs_activity.copy_number = 0
      original_wbs_activity.copy_number = original_wbs_activity.copy_number.to_i+1
    })

    propagate
  end

end
