
# Acquisition categories

FactoryGirl.define do
  factory :acquisition_category do

    description "TBD"

    trait :unknown do
      name "Unknown"
      uuid
      association :record_status, :factory => :proposed_status, strategy: :build
    end

    trait :newDevelopment do
      name "New_Development"
      uuid
      association :record_status, :factory => :proposed_status, strategy: :build
    end

    trait :enhancement do
      name "Enhancement"
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