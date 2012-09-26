#Global attributes of project. Ex : size, cost, result, date etc...
#Those attributes are used into AttributeModule
class Attribute < ActiveRecord::Base

  has_many :attribute_modules, :dependent => :destroy
  has_many :pemodules, :through => :attribute_modules

  serialize :options, Array

  searchable do
    text :name, :description, :alias
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
    val
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

  #Override
  def to_s
    self.name + ' - ' + self.description.truncate(20)
  end

  def data_type
    if self.attr_type == "0"
      "integer"
    elsif self.attr_type == "1"
       "string"
    elsif self.attr_type == "2"
       "date"
    else
       "nil"
    end
  end

end
