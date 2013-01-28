class WbsActivityElement < ActiveRecord::Base
  has_ancestry

  include MasterDataHelper

  attr_accessible :ancestry, :description, :name, :uuid, :wbs_activity_id

  belongs_to :wbs_activity
  belongs_to :pe_wbs_project

  validates :name, :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :wbs_activity_id, :presence => true

  def wbs_activity_name
  end

  def wbs_project_name
    self.pe_wbs_project.nil? ? "" : "#{self.pe_wbs_project.name}"
  end

end
