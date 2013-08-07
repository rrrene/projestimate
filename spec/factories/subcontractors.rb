# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subcontractor do |sub|
    sub.organization_id 1
    sub.name "MyString"
    sub.alias "MyString"
    sub.description "MyText"
  end
end
