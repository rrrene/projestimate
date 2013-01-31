# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wbs_activity do
    uuid "MyString"
    name "MyString"
    state "MyString"
    description "MyText"
    organization_id 1
  end
end
