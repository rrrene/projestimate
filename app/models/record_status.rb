#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012 Spirula (http://www.spirula.fr)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
########################################################################

#Master Data
class RecordStatus < ActiveRecord::Base
  include MasterDataHelper  #Module master data management (UUID generation, deep clone, ...)

  attr_accessible :description, :name

  #belongs_to :record_status
  #has_many :record_statuses

  has_many :acquisition_categories
  has_many :activity_categories
  has_many :attributes
  has_many :attribute_modules
  has_many :currencies
  has_many :event_types
  has_many :labor_categories
  has_many :languages
  has_many :master_settings
  has_many :peicons
  has_many :pemodules
  has_many :platform_categories
  has_many :project_areas
  has_many :project_categories
  has_many :project_security_levels
  has_many :work_element_types

  has_many :admin_settings
  has_many :auth_methods
  has_many :groups
  has_many :permissions

  #self relation for status
  belongs_to :base_status, :class_name => "RecordStatus", :foreign_key => "status_id"
  has_many :children, :class_name => "RecordStatus",  :inverse_of => :base_status, :foreign_key => "status_id"


  #self relation on master data : Parent<->Child
  has_one    :child,  :class_name => "RecordStatus", :inverse_of => :parent, :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "RecordStatus", :inverse_of => :child,  :foreign_key => "parent_id"

  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates :description, :presence => true
  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true, :uniqueness => {:case_sensitive => false, :scope => :record_status_id}
  #TODO validate record_status attribute

end
