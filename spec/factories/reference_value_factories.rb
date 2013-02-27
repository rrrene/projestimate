FactoryGirl.define do

  factory :reference_value do

    trait :all do
      value "All Activity-elements"
    end

    trait :one do
      value "One Activity-element"
    end

    trait :set do
      value "A set of activity-elements"
    end

    factory :all_activity_elements do
       all
    end
  end
end
