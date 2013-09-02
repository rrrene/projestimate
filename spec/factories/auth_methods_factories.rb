## Auth Method

FactoryGirl.define do

  factory :auth_method do
    sequence(:name) {|n| "Application_#{n}"}        #name "Application"
    server_name "not Necessary"
    user_name_attribute "ldap_user"
    port 0
    base_dn "Not necessary"
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build
    encryption "simple_tls"
  end

  factory :auth_methodLDAP do
    sequence(:name) {|n| "Application_#{n}"}        #name "Application"
    server_name "gpsforprojects.net"
    user_name_attribute "ldap_user"
    port 636
    base_dn "ou=People,dc=gpsforprojects,dc=net"
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build
    encryption "simple_tls"
  end

  #Factory for the "Application" AuthMethod

  factory :application_auth_method, :class => :auth_method do
    name "Application"
    server_name "not Necessary"
    user_name_attribute "ldap_user"
    port 0
    base_dn "Not necessary"
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build
    encryption "simple_tls"
  end
end