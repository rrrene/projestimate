FactoryGirl.define do

  factory :permission do |p|
    p.name        "edit_own_profile"
    p.description "Edit your own profile"
    p.alias "edit_own_profile"
    p.is_permission_project true
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build
  end

end