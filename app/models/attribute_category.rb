class AttributeCategory < ActiveRecord::Base
  include MasterDataHelper  #Module master data management (UUID generation, deep clone, ...)

  serialize :options, Array

  attr_accessible :alias, :name, :record_status_id, :custom_value, :change_comment

  has_many :pe_attributes

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates :uuid, :presence => true, :uniqueness => { :case_sensitive => false }
  validates :name, :alias, :presence => true,  :uniqueness => { :scope => :record_status_id, :case_sensitive => false }


  def to_s
    self.name.humanize
  end
end
