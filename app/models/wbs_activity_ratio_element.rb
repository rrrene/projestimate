#encoding: utf-8
class WbsActivityRatioElement < ActiveRecord::Base

  include MasterDataHelper

  belongs_to :wbs_activity_ratio
  belongs_to :wbs_activity_element

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
end
