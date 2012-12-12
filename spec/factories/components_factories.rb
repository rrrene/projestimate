FactoryGirl.define do

  factory :folder, :class => Component do |cl|
    cl.name "Folder1"
    cl.is_root false
    cl.association :work_element_type
  end

  factory :bad, :class => Component do |cl|
    cl.name ""
    cl.is_root false
  end
end
