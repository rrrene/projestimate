# Language

FactoryGirl.define do

  factory :language do
    sequence(:name)   {|n| "language_#{n}"}
    sequence(:locale) {|n| "locale_#{n}"}
    uuid
    association :record_status, :factory => :proposed_status, strategy: :build
  end

  #factory :en_language, :class => Language do
  #  name "English1"
  #  locale "en1"
  #  uuid
  #end
  #
  #factory :fr_language, :class => Language do
  #  name "Français1"
  #  locale "fr1"
  #  uuid
  #end
end
