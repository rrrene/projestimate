#Pemodule represent the Module of the application.
#Pemodule can be commun(sum, average) or typed(cocomo, pnr...)
class Pemodule < ActiveRecord::Base
  #Project has many module, module has many project
  has_many :module_projects
  has_many :projects, :through => :module_projects

  #Pemodule has many attribute, attribute has many pemodule
  has_many :attribute_modules
  has_many :pe_attributes, :source => :attribute, :through => :attribute_modules

  serialize :compliant_component_type

  searchable do
    text :title, :description, :alias
  end

  #Override
  def to_s
    self.title
  end
end
