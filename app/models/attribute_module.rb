#Specific attribute for a module (Fcuntionality)
class AttributeModule < ActiveRecord::Base
  belongs_to :pemodule
  belongs_to :attribute, :class_name => "Attribute"
end
