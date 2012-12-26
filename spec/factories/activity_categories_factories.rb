
FactoryGirl.define do

  factory :activity_category do |ac|
    ac.name         "Management"
    ac.description  "TBD"
    ac.alias        "TBD"
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build
  end

end