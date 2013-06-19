# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attribute_organization do
    pe_attribute_id 1
    organization_id 1
    is_mandatory false
  end
end
