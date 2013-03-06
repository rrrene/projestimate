FactoryGirl.define do
  factory :wbs_activity_ratio do
    uuid
    sequence(:name){|n| "Ratio_#{n}"}
    description "TBD"
    association :record_status, :factory => :local_status, strategy: :build
  end
end