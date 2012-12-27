
FactoryGirl.define do

  factory :project_security_level do

    association :record_status, :factory => :proposed_status, strategy: :build

    trait :readOnly do
      sequence(:name) {|n| "ReadOnly_#{n}"}
      uuid
    end

    factory :readOnly_project_security_level do
      readOnly
    end

  end
end