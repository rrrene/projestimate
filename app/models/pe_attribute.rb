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
class PeAttribute < ActiveRecord::Base
  include MasterDataHelper  #Module master data management (UUID generation, deep clone, ...)

  serialize :options, Array

  has_many :attribute_modules, :dependent => :destroy
  has_many :pemodules, :through => :attribute_modules
  has_many :estimation_values

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates_presence_of :description, :attr_type, :record_status
  validates :uuid, :presence => true, :uniqueness => { :case_sensitive => false }
  validates :name, :alias, :presence => true,  :uniqueness => { :scope => :record_status_id, :case_sensitive => false }
  validates :custom_value, :presence => true, :if => :is_custom?

  ##Enable the amoeba gem for deep copy/clone (dup with associations)
  amoeba do
    enable
    exclude_field [:attribute_modules]

    customize(lambda { |original_record, new_record|
      new_record.reference_uuid = original_record.uuid
      new_record.reference_id = original_record.id
      new_record.record_status = RecordStatus.find_by_name("Proposed") #RecordStatus.first
    })
  end

  searchable do
    text :name, :description, :alias
  end

  def self.attribute_list
    PeAttribute.all.map(&:alias)
  end

  def self.attribute_updated_at
    PeAttribute.all.map(&:updated_at)
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
    [["Integer", "integer" ] ,["Float", "float"], ["Date", "date" ], ["Text", "text" ], ["List", "list" ]]
  end

  def self.value_options
    [
     ["Greater than or equal to", ">=" ],
     ["Greater than", ">" ],
     ["Lower than or equal to", "<=" ],
     ["Lower than", "<" ],
     ["Equal to", "=="],
     ["Not equal to", "!="],
     ["Between", "between"]
    ]
  end

  #return the data type
  def data_type
    self.attr_type
  end

  #return the data type
  def attribute_type
    case self.attr_type
      when "integer"
        "numeric"
      when "float"
        "numeric"
      when "date"
        "date"
      when "text"
        "string"
      when "list"
        "string"
      when "array"
        "string"
    end
  end

    #return the data type
  def explicit_data_type
    case self.attr_type
      when "integer"
        "numeric"
      when "float"
        "numeric"
      when "date"
        "date"
      when "text"
        "string"
      when "list"
        "string"
      when "array"
        "string"
    end
  end

  # Verify if params val is validate
  def is_validate(val)
    pe_attribute = self.pe_attribute
    #if value is mandatory and not fill => false
    if self.is_mandatory and val.blank?
      false
      #if value is not mandatory and not fill => true
    elsif val.blank?
      true
      #if value is filled...
    else
      #deserialize options to do something like that : ['integer', '>=', 50]
      array = pe_attribute.options.compact.reject { |s| s.nil? or s.empty? or s.blank? }

      #test attribute type and check validity (numeric = float and integer)
      if pe_attribute.attribute_type == 'numeric'

        if pe_attribute.attr_type == 'integer'
          return val.valid_integer?
        end

        unless val.is_numeric?
          #return false is value is not numeric
          return false
        end

        #unless there are not conditions/options
        unless array.empty?
          #number between 1 and 10 (ex : 3 = true, 15 = false, -5 = false)
          if pe_attribute.options[1] == 'between'
            v1 = pe_attribute.options[2].split(';').first.to_i
            v2 = pe_attribute.options[2].split(';').last.to_i
            val.to_i.between?(v1, v2)
          else
            #ex : eval('val <= 42')
            str = array[1] + array[2]
            str_to_eval = val + str.to_s
            begin
              eval(str_to_eval)
            rescue Exception => se
              return false
            end
          end
        else
          return true
        end

        #test class of val but not really good because '15565' is also an string
      elsif pe_attribute.attribute_type == 'string'
        val.class == String
        #test validity of date. Problem with translated date (fr: 28/02/2013 => true en: 02/28/2013 => false but both valid)
      elsif pe_attribute.attribute_type == 'date'
        str_to_eval = "'#{val}'.to_date #{ array[1]} '#{array[2]}'.to_date"
        begin
          #eval chain
          eval(str_to_eval)
        rescue Exception => se
          return false
        end
      end
    end
  end


end
