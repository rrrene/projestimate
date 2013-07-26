
#PeAttributes
FactoryGirl.define do
  factory :quality_in_use, :class => :attribute_category  do |attr|
     attr.name "Quality in use"
     attr.alias "quality_in_use"
     uuid
     association :record_status, :factory => :proposed_status, strategy: :build
  end

  factory :product_quality, :class => :attribute_category do |attr|
     attr.name "Product Quality"
     attr.alias "product_quality"
     uuid
     association :record_status, :factory => :proposed_status, strategy: :build
  end
end