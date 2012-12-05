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

#Component of the WBS. Component belongs to a type (dev, cots, folder, link...)
#Component use Ancestry gem (has_ancestry). See ancestry on github for more informations.
class Component < ActiveRecord::Base
  has_ancestry

  belongs_to :wbs
  belongs_to :work_element_type

  has_many :module_project_attributes

  validates_presence_of :name

  #Sunspot needs
  searchable do
    text :name
  end

  #Metaprogrammation
  #Generate an method folder?, link?, etc...
  #Usage: component1.folder?
  #Return a boolean.
  types_wet = WorkElementType::work_element_type_list
  types_wet.each do |type|
    define_method("#{type}?") do
      (self.work_element_type.alias == type) ? true : false
    end
  end

  #Generate an method numeric_data_low or numeric_data_ml etc...
  #Usage: component1.numeric_data_high
  #Return correct value.
  #attr_list = Attribute::attribute_list
  attr_list = Object::Attribute::attribute_list
  attr_list.each do |attr|
    define_method("#{attr}") do
      res = Array.new
      %w(low most_likely high).each do |level|
        res << self.module_project_attributes.keep_if{ |i| i.attribute.alias == attr }.map{|j| j.send("numeric_data_#{level}") }
      end
      return res.flatten
    end

    %w(low most_likely high).each do |level|
      define_method("#{attr}_#{level}") do
        self.module_project_attributes.select{ |i| i.attribute.alias == attr }.map{|j| j.send("numeric_data_#{level}") }
      end
    end
  end

  #Override
  def to_s
    self.name
  end

end
