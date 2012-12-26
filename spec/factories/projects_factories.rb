#Project

FactoryGirl.define do

  # Projects
  factory :project do |p|
    p.sequence(:title) {|n| "Projet_#{n}"}
    p.sequence(:alias) {|n| "P#{n}"}
    p.sequence(:description) {|n| "Projet number #{n}"}
    p.state "preliminary"
    p.start_date Time.now
  end

end