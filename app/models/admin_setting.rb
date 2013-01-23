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

# Special table
class AdminSetting < ActiveRecord::Base
  include MasterDataHelper  #Module master data management (UUID generation, deep clone, ...)

  #self relation on master data : Parent<->Child
  has_one    :child_reference,  :class_name => "AdminSetting", :inverse_of => :parent_reference, :foreign_key => "reference_id"
  belongs_to :parent_reference, :class_name => "AdminSetting", :inverse_of => :child_reference,  :foreign_key => "reference_id"

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates :record_status, :presence => true
  validates :value, :presence => true, :unless => :is_custom_value_to_consider?
  validates :uuid, :presence => true, :uniqueness => { :case_sensitive => false }
  validates :key,  :presence => true, :uniqueness => { :scope => :record_status_id, :case_sensitive => false }
  validates :custom_value, :presence => true, :if => :is_custom?

  def is_custom_value_to_consider?
    self.key == "custom_status_to_consider"
  end
end
