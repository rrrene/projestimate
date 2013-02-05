# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wbs_activity_element do
    uuid
    sequence(:name) {|n| "Wbs-Activity #{n}"}
    description "TBD"
    association :record_status, :factory => :proposed_to_save_status
    association :wbs_activity,  :factory => :wbs_activity
  end

end
