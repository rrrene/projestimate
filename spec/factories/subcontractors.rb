# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subcontractor do
    organization_id 1
    name "MyString"
    subcontractor_alias "MyString"
    description "MyText"
  end
end
