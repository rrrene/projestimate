class Subcontractor < ActiveRecord::Base
  attr_accessible :description, :name, :organization_id, :alias

  belongs_to :organization

  validates :name, :alias, :presence => true, :uniqueness => { :scope => :organization_id, :case_sensitive => false }
end
