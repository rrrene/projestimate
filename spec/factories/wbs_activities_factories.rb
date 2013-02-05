# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wbs_activity do
    uuid
    sequence(:name) {|n| "Wbs-Activity #{n}"}
    state "Defined"
    description "MyText"
    association :record_status, :factory => :proposed_status, strategy: :build
  end

end
