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
#WorkElementType has many components and belongs to project_area. WET can be "development", "cots" but also "folder" and "link"
class WorkElementType < ActiveRecord::Base
  include UUIDHelper   #module for UUID generation

  has_many :components

  #self relation on master data : Parent<->Child
  has_one    :child,  :class_name => "WorkElementType", :inverse_of => :parent
  belongs_to :parent, :class_name => "WorkElementType", :inverse_of => :child, :foreign_key => "parent_id"

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  belongs_to :project_area
  belongs_to :peicon

  validates :name, :alias, :presence => true, :uniqueness => {:case_sensitive => false}

  #Sunspot needs
  searchable do
    text :name, :description, :alias
  end

  def self.work_element_type_list
    Object::WorkElementType.all.map(&:alias)
  end

  #Override
  def to_s
    self.name
  end
end
