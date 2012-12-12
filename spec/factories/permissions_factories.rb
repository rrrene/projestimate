FactoryGirl.define do

  factory :permission do |p|
    p.name        "edit_own_profile"
    p.description "Edit your own profile"
    p.is_permission_project false
  end

end