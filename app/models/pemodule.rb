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
#Pemodule represent the Module of the application.
#Pemodule can be commun(sum, average) or typed(cocomo, pnr...)
class Pemodule < ActiveRecord::Base
  include UUIDHelper   #module for UUID generation

  #Project has many module, module has many project
  has_many :module_projects
  has_many :projects, :through => :module_projects

  #Pemodule has many attribute, attribute has many pemodule
  has_many :attribute_modules
  has_many :pe_attributes, :source => :attribute, :through => :attribute_modules

  #self relation on master data : Parent<->Child
  has_one    :child,  :class_name => "Pemodule", :inverse_of => :parent
  belongs_to :parent, :class_name => "Pemodule", :inverse_of => :child, :foreign_key => "parent_id"

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  serialize :compliant_component_type

  validates_presence_of :title, :alias, :description

  searchable do
    text :title, :description, :alias
  end

  #Override
  def to_s
    self.title
  end
end
