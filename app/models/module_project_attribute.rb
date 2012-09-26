#Module Attribute are duplicated on AttributeProject in order to use it.
class ModuleProjectAttribute < ActiveRecord::Base
  has_ancestry

  belongs_to :attribute
  belongs_to :module_project
  belongs_to :component

  has_and_belongs_to_many :links,
                          :class_name => "ModuleProjectAttribute",
                          :association_foreign_key => "link_id",
                          :join_table => "links_module_project_attributes"


  #Metaprogrammation
  #input or output
  MPA = ModuleProjectAttribute.all.map(&:in_out)
  MPA.each do |type|
    define_method("#{type}?") do
      (self.in_out == type) ? true : false
    end
  end

  #Hum...?
  def select_custom_attribute
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
