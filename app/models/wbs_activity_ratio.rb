#encoding: utf-8
class WbsActivityRatio < ActiveRecord::Base

  include MasterDataHelper

  belongs_to :wbs_activity
  has_many :wbs_activity_ratio_elements, :dependent => :destroy

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true, :uniqueness => { :scope => :record_status_id, :case_sensitive => false}
  validates :custom_value, :presence => true, :if => :is_custom?

  #Enable the amoeba gem for deep copy/clone (dup with associations)
  amoeba do
    enable

    customize(lambda { |original_wbs_activity_ratio, new_wbs_activity_ratio|

      new_wbs_activity_ratio.name = "Copy_#{ original_wbs_activity_ratio.copy_number.to_i+1} of #{original_wbs_activity_ratio.name}"

      new_wbs_activity_ratio.copy_number = 0
      original_wbs_activity_ratio.copy_number = original_wbs_activity_ratio.copy_number.to_i+1
    })

    propagate
  end

end
