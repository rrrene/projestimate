
# Acquisition categories

FactoryGirl.define do
  factory :acquisition_category do
    description "TBD"

    trait :unknown do
      sequence(:name) { |n| "Unknown#{n}" }
      uuid
      association :record_status, :factory => :proposed_status, :strategy => :build

    end

    trait :newDevelopment do
      sequence(:name) { |n| "New_Development#{n}" }
      uuid
      association :record_status, :factory => :proposed_status, strategy: :build
    end

    trait :enhancement do
      sequence(:name) { |n| "Enhancement#{n}" }
      uuid
      association :record_status, :factory => :proposed_status, strategy: :build
    end

  end


  ##Default acquisition category
  #acquisition_category = Array.new
  #acquisition_category = [
  #  ["Unknown","TBD"],
  #  ["New_Development","TBD"],
  #  ["Enhancement","TBD"],
  #  ["Re_development","TBD"],
  #  ["POC","TBD"],
  #  ["Purchased","TBD"],
  #  ["Porting","TBD"],
  #  ["Other","TBD"]
  #]
  #
  #acquisition_category.each do |ac|
  #  factory ":#{ac[0]}_acquisition_categort", :class => AcquisitionCategory do
  #    name "#{ac[0]}"
  #    description "#{ac[1]}"
  #  end
  #end


end