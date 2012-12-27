# Platform Category
FactoryGirl.define do

  factory :platform_category do

    uuid
    description "TBD"
    association :record_status, :factory => :proposed_status, strategy: :build

    trait :unknown do
      sequence(:name) {|n| "Unknown_#{n}"}
      uuid
    end

    trait :client_server do
      sequence(:name) {|n| "Client-Server#{n}"}  #name  "Client-Server"
      description  "TBD"
      uuid
    end

    trait :mobile_ground_based do
      sequence(:name) {|n| "Mobile Ground-Based#{n}"} #name  "Mobile Ground-Based"
      uuid
    end

    trait :pserver do
      sequence(:name) {|n| "Server#{n}"} #name "Server"
      uuid
    end

    trait :telecommunications do
      sequence(:name) {|n| "Telecommunications#{n}"} #name "Telecommunications"
      uuid
    end

    trait :web_base_dev do
      sequence(:name) {|n| "Web Based Development#{n}"} #name "Web Based Development"
      uuid
    end


    factory :unknown_platform_category do
      unknown
    end

    factory :client_server_platform_category do
      client_server
    end

    factory :mobile_ground_based_platform_category do
      mobile_ground_based
    end

    factory :server_platform_category do
      pserver
    end

    factory :telecommunications_platform_category do
      telecommunications
    end

    factory :web_base_dev_platform_category do
      web_base_dev
    end
  end
end
