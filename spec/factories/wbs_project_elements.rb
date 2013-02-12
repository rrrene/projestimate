# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wbs_project_element do
    #wbs_activity_element_id 1
    #wbs_activity_id 1

    sequence(:name) {|n| "Wbs-Project-Element #{n}"}
    description "TBD"
    additional_description "MyText"
    exclude false
  end
end
