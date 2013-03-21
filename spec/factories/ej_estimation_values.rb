# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ej_estimation_value do
    project_id 1
    pbs_project_element_id 1
    wbs_activity_element_id 1
    minimum 1.5
    most_likely 1.5
    maximum 1.5
    probable 1.5
  end
end
