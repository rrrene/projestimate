#Component of the WBS. Component belongs to a type (dev, cots, folder, link...)
#Component use Ancestry gem (has_ancestry). See ancestry on github for more informations.
class Component < ActiveRecord::Base
  has_ancestry
  belongs_to :wbs
  belongs_to :work_element_type
  has_many :module_project_attributes

  #Sunspot needs
  searchable do
    text :name
  end

  #Metaprogrammation
  #Generate an method folder?, link?, etc...
  #Usage: component1.folder?
  #Return a boolean.
  TYPES_WET = WorkElementType.all.map(&:alias)
  TYPES_WET.each do |type|
    define_method("#{type}?") do
      (self.work_element_type.alias == type) ? true : false
    end
  end

  #Metaprogrammation
  #Generate an method numeric_data_low or numeric_data_ml etc...
  #Usage: component1.numeric_data_high
  #Return correct value.
  ATTRIBUTES = Attribute.all.map(&:alias)
  ATTRIBUTES.each do |attr|
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
