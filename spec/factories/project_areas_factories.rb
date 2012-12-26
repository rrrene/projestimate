#
FactoryGirl.define do

  #Default project area
  factory :project_area do
    sequence(:name) {|n| "SW Project #{n}"}
    description  "Software"
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build
  end
end