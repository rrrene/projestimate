FactoryGirl.define do
  factory :labor_category do
    name "Consultant_test"
    description "TBD"
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build
  end
end