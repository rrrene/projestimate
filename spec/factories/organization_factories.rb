#
FactoryGirl.define do

  # Organizations
  factory :organization do
    sequence(:name) {|n| "Organization_#{n}"}
    sequence(:description) {|n| "Organisation number #{n}"}
  end

end