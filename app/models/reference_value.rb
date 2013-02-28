class ReferenceValue  < ActiveRecord::Base
  include MasterDataHelper  #Module master data management (UUID generation, deep clone, ...)

  has_many :wbs_activity_ratios

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates :record_status, :presence => true##, :if => :on_master_instance?   #defined in MasterDataHelper
  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :value, :presence => true, :uniqueness => { :scope => :record_status_id, :case_sensitive => false}
end