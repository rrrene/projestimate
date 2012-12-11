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

#Master table
#Sous-découpage du domaine du projet (elle est lié à la table ProjectAreas).
class ActivityCategory < ActiveRecord::Base
  include UUIDHelper    #module for UUID generation

  has_and_belongs_to_many :project_areas

  belongs_to :record_status
  belongs_to :user, :foreign_key => "owner_id"

  validates_presence_of :name, :description, :alias

  # This set the record UUID on :create  as a :before_create method
  def set_uuid
    #self.uuid = UUI
  end


  def to_s
    name
  end
end
