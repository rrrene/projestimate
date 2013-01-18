# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wbs_activity_element do
    uuid "MyString"
    wbs_activity_id 1
    name "MyString"
    description "MyText"
    ancestry "MyString"
  end
end
