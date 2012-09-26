#encoding: utf-8
#Permission  of the users and the groups
class Permission < ActiveRecord::Base

  has_and_belongs_to_many :users
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :project_security_levels

end
