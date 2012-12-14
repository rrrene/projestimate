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
#Language of the User
class Language < ActiveRecord::Base
  include UUIDHelper   #module for UUID generation

  has_many :users

  #self relation : Parent<->Child
  has_one    :child,  :class_name => "Language", :inverse_of => :parent, :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Language", :inverse_of => :child, :foreign_key => "parent_id"

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates_presence_of :name
  validates_presence_of :locale

  #For record deep copy
  amoeba do

    enable

    customize(lambda { |original_language, new_language|
      new_language.ref = original_language.uuid
      new_language.parent = original_language
      new_language.record_status = RecordStatus.first
    })
  end

  #Override
  def to_s
    self.name
  end

  #Define method for record_status
  define_method(:is_proposed?) do
    (self.record_status.name == "Proposed") ? true : false
  end

end
