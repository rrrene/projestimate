FactoryGirl.define do

  #PeWbsProject
  factory :pe_wbs_project do
    sequence(:name){|n| "Pe-Wbs-Project_Root #{n}"}
  end

  factory :wbs_1, class: PeWbsProject do
    sequence(:name)   {|n| "Pe-WBS-Project_#{n}"}
  end

end
