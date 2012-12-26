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
#Global attributes of project. Ex : size, cost, result, date etc...
#Those attributes are used into AttributeModule
class Attribute < ActiveRecord::Base
  include MasterDataHelper  #Module master data management (UUID generation, deep clone, ...)

  serialize :options, Array

  has_many :attribute_modules, :dependent => :destroy
  has_many :pemodules, :through => :attribute_modules

  #self relation on master data : Parent<->Child
  has_one    :child,  :class_name => "Attribute", :inverse_of => :parent, :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Attribute", :inverse_of => :child,  :foreign_key => "parent_id"

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates_presence_of :description, :attr_type, :record_status
  validates :name, :alias, :uuid, :presence => true,  :uniqueness => { :case_sensitive => false }

  searchable do
    text :name, :description, :alias
  end

  def self.attribute_list
    Object::Attribute.all.map(&:alias)
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
        eval(str_to_eval)
      rescue Exception => se
        return false
      end
    else
      return true
    end
  end

  #return the data type
  def data_type
    self.attr_type
  end

end
