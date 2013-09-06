
#PeAttributes
FactoryGirl.define do
  factory :cost_attribute, :class => :pe_attribute  do |attr|
     attr.name "Cost"
     attr.alias "cost"
     attr.description "Cost desc"
     attr.attr_type "integer"
     attr.options []
     uuid
     association :record_status, :factory => :proposed_status, strategy: :build
  end

  factory :ksloc_attribute, :class => :pe_attribute do |attr|
     attr.name "Ksloc1"
     attr.alias "ksloc1"
     attr.description "Attribute number 1"
     attr.attr_type "integer"
     attr.options ["integer", ">=", "10"]
     uuid
     association :record_status, :factory => :proposed_status, strategy: :build
  end
end