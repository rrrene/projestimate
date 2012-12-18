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

#Special Data
#Group class contains some User.
class Group < ActiveRecord::Base
  include MasterDataHelper  #Module master data management (UUID generation, deep clone, ...)

  #self relation on master data : Parent<->Child
  has_one    :child,  :class_name => "Group", :inverse_of => :parent, :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Group", :inverse_of => :child,  :foreign_key => "parent_id"

  has_and_belongs_to_many :users
  has_and_belongs_to_many :projects

  has_many :project_securities

  has_and_belongs_to_many :permissions

  validates :name, :presence => true, :uniqueness => true

  #Override
  def to_s
    self.name
  end

  #TODO REVIEW function code
  #Return group project_securities for selected project_id
  def project_securities_for_select(prj_id)
    self.project_securities.select{ |i| i.project_id == prj_id }.first
  end

end
