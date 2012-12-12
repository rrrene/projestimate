FactoryGirl.define do
  factory :user do
    first_name "Administrator1"
    last_name  "Projestimate1"
    login_name "admin1"
    email      "admin1@yourcompany.net"
    initials   "ad1"
    auth_method
    user_status "active"
    language
    password   "projestimate1"
    password_confirmation "projestimate1"
  end

  #factory :unknown_project_category, :class => ProjectCategory do
  #  name "Unknown"
  #  description  "TBD"
  #end


  #trait :admin2 do
  #  first_name "Administrator2"
  #  last_name  "Projestimate2"
  #  login_name "admin2"
  #  email      "admin2@yourcompany.net"
  #  initials   "ad2"
  #end
  #
  #trait :fact1 do
  #  first_name "Administrator1"
  #  last_name  "Projestimate1"
  #  login_name "admin1"
  #  email      "admin1@yourcompany.net"
  #  initials   "ad1"
  #end

  factory :auth_method do  |auth|
    auth.name "Application"
    auth.server_name "not Necessary"
    auth.port 0
    auth.base_dn "Not necessary"
    auth.certificate 0
  end

  factory :language do
    name "Test"
    locale "This is a test"
  end

  factory :ProjectCategory do
    name "projet1"
    description "en"
  end

  # Projects
  factory :project do |p|
    p.title "Projet1"
    p.description "Projet N1"
    p.alias "P1"
    p.state "Preliminary"
    p.start_date Time.now
  end

  ## project_security
  #factory :project_security do |p|
  #  p.user_id 1
  #  p.project_id 1
  #  p.group_id 1
  #  p.project_security_level_id 1
  #end
  #
  ## project_security_level
  #factory :project_security_level do |p|
  #  p.id 1
  #  p.name "read"
  #end

  # Organizations
  factory :organization do
    name "Organisation1"
    description "Organisation number 1"
  end

  # Components
  factory :component do
    name "Root compoment"
    is_root true
    wbs
  end

  #Wbs
  factory :wbs do
    project
  end

  factory :wbs_1, class: Wbs do
  end

  factory :attribute, :class => Attribute do |attr|
     attr.name "attr"
     attr.alias "attr"
     attr.description "Attr"
     attr.attr_type "Integer"
     attr.options []
  end


  #Pemodule
  #factory :pemodule do |mo|
  #  mo.title "Cocomo basic"
  #  mo.alias "cocomo_basic"
  #  mo.description "cocomo très basic"
  #end

end