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
#ProjectArea management
class ProjectArea < ActiveRecord::Base
  include MasterDataHelper  #Module master data management (UUID generation, deep clone, ...)

  has_and_belongs_to_many :activity_categories
  has_and_belongs_to_many :labor_categories
  has_and_belongs_to_many :platform_categories
  has_and_belongs_to_many :acquisition_categories
  has_and_belongs_to_many :project_categories

  #self relation on master data : Parent<->Child
  has_one    :child,  :class_name => "ProjectArea", :inverse_of => :parent, :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "ProjectArea", :inverse_of => :child,  :foreign_key => "parent_id"

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  belongs_to :project

  validates_presence_of :description, :record_status
  validates  :name, :uuid, :presence => true, :uniqueness => {:case_sensitive => false}

  #Sunspot needs
  searchable do
    text :name, :description
  end

  #Override
  def to_s
    self.name
  end
end
