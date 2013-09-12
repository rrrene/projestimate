#Project

FactoryGirl.define do

  # Projects
  factory :project do |p|
    p.sequence(:title) {|n| "Project_#{n}"}
    p.sequence(:alias) {|n| "P#{n}"}
    p.sequence(:description) {|n| "Project number #{n}"}
    p.state 'preliminary'
    p.start_date Time.now
  end

end