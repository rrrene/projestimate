FactoryGirl.define do
  factory :reference_value do
    association :record_status, :factory => :defined_status, strategy: :build

    trait :a_set_of_activity_elements do
      sequence(:value){|n| "A set of activity-elements #{n}" }
    end

    trait :all_activity_elements do
      sequence(:value){|n| "All Activity-elements #{n}" }
    end

    trait :one_activity_elements do
      sequence(:value){|n| "One Activity-element #{n}" }
    end
  end
end