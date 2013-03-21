# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :version do
    local_latest_update "2013-03-19 14:28:31"
    repository_latest_update "2013-03-19 14:28:31"
    comment "MyText"
  end
end
