FactoryGirl.define do
  factory :user do
    first_name "Administrator"
    last_name  "Projestimate"
    login_name "admin"
    initials   "ad"
    email      "youremail@yourcompany.net"
    auth_method
    user_status "active"
    language
    password   "projestimate"
    password_confirmation "projestimate"
  end

  factory :auth_method do  |auth|
    auth.name "Application"
    auth.server_name "not Necessary"
    auth.port 0
    auth.base_dn "Not necessary"
    auth.user_name_attribute nil
    auth.certificate 0
    auth.scope nil
  end

  factory :language do
    name "English"
    locale "en"
  end

  factory :project do |p|
    p.title "Projet1"
    p.description "Projet N1"
    p.alias "P1"
    p.state "Preliminary"
    p.start_date Time.now
  end

  factory :organization do
    name "Organisation1"
    description "Organisation number 1"
  end

  factory :component do
    name "Root compoment"
    is_root true
    wbs
  end

  factory :wbs do
    project
  end

  factory :wbs_1, class: Wbs do

  end
end