class ProjectSecurityLevel < ActiveRecord::Base
  has_many :project_securities
  has_and_belongs_to_many :permissions
end
