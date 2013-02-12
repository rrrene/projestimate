  #encoding: utf-8
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
  has_many :wbs_activity_ratios, :dependent => :destroy

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true, :uniqueness => { :scope => :record_status_id, :case_sensitive => false}
  validates :custom_value, :presence => true, :if => :is_custom?

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
