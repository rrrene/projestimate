## Read about factories at https://github.com/thoughtbot/factory_girl
#
FactoryGirl.define do

  factory :record_status do
      trait :proposed do
        name "Proposed"
        description "TBD"
        uuid
      end

      trait :inReview do
        name "InReview"
        description "TBD"
        uuid
      end

      trait :draft do
        name "Draft"
        description "TBD"
        uuid
      end

      trait :defined do
        name "Defined"
        description "TBD"
        uuid
      end

      trait :retired do
        name "Retired"
        description "TBD"
        uuid
      end

      trait :custom do
        name "Custom"
        description "TBD"
        uuid
      end
  end
end
