FactoryGirl.define do

  factory :group do
    sequence(:name) {|n| "group#{n}"}
    sequence(:description) {|n| "Group number #{n}"}
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build
    for_global_permission true
  end

end