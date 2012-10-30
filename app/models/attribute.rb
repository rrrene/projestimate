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

#Global attributes of project. Ex : size, cost, result, date etc...
#Those attributes are used into AttributeModule
class Attribute < ActiveRecord::Base

  has_many :attribute_modules, :dependent => :destroy
  has_many :pemodules, :through => :attribute_modules

  serialize :options, Array

  validates_presence_of :name, :description, :alias, :attr_type

  searchable do
    text :name, :description, :alias
  end

  #Override
  def to_s
    self.name + ' - ' + self.description.truncate(20)
  end

  #Type of the aggregation
  #Not finished
  def self.type_aggregation
    [["Moyenne", "average" ] ,["Somme", "sum"], ["Maximum", "maxi" ]]
  end

  def self.type_values
    [["Integer", "integer" ] ,["Float", "float"], ["Date", "date" ], ["Text", "text" ], ["List", "list" ],["Array", "array"]]
  end

  def self.value_options
    [
     ["Greater than or equal to", ">=" ],
     ["Greater than", ">" ],
     ["Lower than or equal to", "<=" ],
     ["Lower than", "<" ],
     ["Equal to", "=="],
     ["Not equal to", "!="]
    ]
  end

  # Verify if params val is validate
  def is_validate(val)
    array = self.options.compact.reject { |s| s.nil? or s.empty? or s.blank? }
    unless array.empty?
      str = array[1] + array[2]
      str_to_eval = val + str.to_s
      begin
        res = eval(str_to_eval)
        if res.nil?
          return true
        else
          return res
        end
      rescue
        puts "Not compatible to an evaluation"
        return true
      end
    else
      return true
    end
  end

  #TODO:metaprog
  def data_type
    self.attr_type
  end

end
