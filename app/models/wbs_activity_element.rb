class WbsActivityElement < ActiveRecord::Base
  include MasterDataHelper

  has_ancestry

  #attr_accessible :ancestry, :description, :name, :uuid, :wbs_activity_id

  #self relation on master data : Parent<->Child
  #has_one    :child,  :class_name => "WbsActivityElement", :inverse_of => :parent, :foreign_key => "parent_id"
  #belongs_to :parent, :class_name => "WbsActivityElement", :inverse_of => :child,  :foreign_key => "parent_id"
  has_one    :child_reference,  :class_name => "WbsActivityElement", :inverse_of => :parent_reference, :foreign_key => "reference_id"
  belongs_to :parent_reference, :class_name => "WbsActivityElement", :inverse_of => :child_reference,  :foreign_key => "reference_id"

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  belongs_to :wbs_activity
  belongs_to :pe_wbs_project


  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true, :uniqueness => { :scope => :record_status_id, :case_sensitive => false}
  validates :wbs_activity_id, :presence => true
  validates :custom_value, :presence => true, :if => :is_custom?

  def wbs_activity_name
  end

  def wbs_project_name
    self.pe_wbs_project.nil? ? "" : "#{self.pe_wbs_project.name}"
  end

end
