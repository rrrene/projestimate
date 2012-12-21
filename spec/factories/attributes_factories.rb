
#Attributes
FactoryGirl.define do
  factory :cost_attribute, :class => :attribute  do |attr|
     attr.name "Cost"
     attr.alias "cost"
     attr.description "Cost desc"
     attr.attr_type "Integer"
     attr.options []
    uuid
  end

  factory :ksloc_attribute, :class => :attribute do |attr|
     attr.name "Ksloc1"
     attr.alias "ksloc1"
     attr.description "Attribut number 1"
     attr.attr_type "Integer"
     attr.options ["integer", ">=", "10"]
     uuid
  end
end