FactoryGirl.define do
  factory :wbs_activity_ratio_element do
    uuid
    association :record_status, :factory => :defined_status, strategy: :build
  end
end