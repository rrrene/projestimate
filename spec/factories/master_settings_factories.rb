# Master Setting
FactoryGirl.define do

  factory :master_setting do
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build

    trait :wiki_url do
      sequence(:key) {|n| "url_wiki_#{n}"}
      value "http://forge.estimancy.com/projects/pe/wiki"
    end

    trait :service_url do
      sequence(:key) {|n| "url_service_#{n}"}
      value "httpforge.estimancy.comorg/projects/pe/wiki/Community_Services"
    end

    factory :master_setting_wiki_url do
      wiki_url
    end

    factory :master_setting_service_url do
      service_url
    end

  end
end