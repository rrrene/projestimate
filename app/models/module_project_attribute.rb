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

#Module Attribute are duplicated on AttributeProject in order to use it.
class ModuleProjectAttribute < ActiveRecord::Base
  has_ancestry

  belongs_to :attribute
  belongs_to :module_project
  belongs_to :pbs_project_element

  has_and_belongs_to_many :links,
                          :class_name => "ModuleProjectAttribute",
                          :association_foreign_key => "link_id",
                          :join_table => "links_module_project_attributes"


  #Metaprogrammation
  #input or output
  ModuleProjectAttribute.all.map(&:in_out).each do |type|
    define_method("#{type}?") do
      (self.in_out == type) ? true : false
    end
  end

  def custom_attribute?
    if self.custom_attribute == "user"
      true
    else
      false
    end
  end

  def to_s
    self.attribute.name
  end
end
