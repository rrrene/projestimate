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
class EstimationValue < ActiveRecord::Base
  has_ancestry

  belongs_to :attribute
  belongs_to :module_project
  belongs_to :pbs_project_element

  #Serialize some output data for estimatin result
  serialize :numeric_data_low
  serialize :numeric_data_most_likely
  serialize :numeric_data_high

  #Metaprogrammation
  #input or output
  EstimationValue.all.map(&:in_out).each do |type|
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
