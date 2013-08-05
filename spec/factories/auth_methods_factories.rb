## Auth Method

FactoryGirl.define do

  factory :auth_method do
    sequence(:name) {|n| "Application_#{n}"}        #name "Application"
    server_name "not Necessary"
    port 0
    base_dn "Not necessary"
    certificate 0
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build
  end

  factory :auth_methodLDAP do
    sequence(:name) {|n| "Application_#{n}"}        #name "Application"
    server_name "gpsforprojects.net"
    port 636
    base_dn "ou=People,dc=gpsforprojects,dc=net"
    certificate 0
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build
  end

  #Factory for the "Application" AuthMethod

  factory :application_auth_method, :class => :auth_method do
    name "Application"
    server_name "not Necessary"
    port 0
    base_dn "Not necessary"
    certificate 0
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build
  end
end