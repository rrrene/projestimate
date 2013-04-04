require "rubygems"
require "uuidtools"

FactoryGirl.define do

  #sequence to generate UUID on test records
  sequence :uuid do |n|
    "#{UUIDTools::UUID.random_create.to_s}"
  end

  sequence :login_name do |n|
    "login_name_#{n}"
  end

  sequence :email do |n|
    "email_#{n}@yahoo.fr"
  end

  sequence :password_reset_token do |n|
    "#{SecureRandom.urlsafe_base64}"
  end

  #factory :user do
  #  first_name "Administrator1"
  #  last_name  "Projestimate1"
  #  login_name "admin1"
  #  email      "admin1@yourcompany.net"
  #  initials   "ad1"
  #  auth_method
  #  user_status "pending"
  #  language
  #  password   "projestimate1"
  #  password_confirmation "projestimate1"
  #end

  factory :user do
    first_name "Administrator1"
    last_name  "Projestimate1"
    login_name "admin1"
    email      "admin1@yourcompany.net"
    initials   "ad1"
    association :auth_method, :factory => :auth_method
    user_status "pending"
    association :language, :factory => :language
    password   "projestimate1"
    password_confirmation "projestimate1"
    password_reset_token
  end

  factory :user2, :class => User do
    first_name #"Administrator2"
    last_name  #"Projestimate2"
    login_name #"admin2"
    email      "youremail2@yourcompany.net"
    initials   #"ad2"
    association :auth_method, :factory => :auth_method, strategy: :build
    user_status "pending"
    association :language, :factory => :language, :strategy => :build
    password   "projestimate2"
    password_confirmation "projestimate2"
  end

  #factory :unknown_project_category, :class => ProjectCategory do
  #  name "Unknown"
  #  description  "TBD"
  #end


  factory :ProjectCategory do
    name "projet1"
    description "en"
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build
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


  # Components
  factory :pbs_project_element_first, :class => PbsProjectElement do
    name "Root compoment"
    is_root true
    pe_wbs_project
  end

  factory :attribute, :class => Attribute do |attr|
     attr.name "attr"
     attr.alias "attr"
     attr.description "Attr"
     attr.attr_type "Integer"
     attr.options []
     uuid
     association :record_status, :factory => :proposed_status, strategy: :build
  end


  #Pemodule
  #factory :pemodule do |mo|
  #  mo.title "Cocomo basic"
  #  mo.alias "cocomo_basic"
  #  mo.description "cocomo très basic"
  #end

end