FactoryGirl.define do

  #factory :folder, :class => Component do |cl|
  #  cl.name "Folder1"
  #  cl.is_root false
  #  cl.association :work_element_type#, :factory =>  :work_element_type_folder
  #end

  #factory :component do
  #  name "Component"
  #  is_root false
  #
  #  trait :folder do
  #    name "Folder1"
  #  end
  #
  #  trait :bad do
  #    name "bad"
  #  end
  #end

  factory :folder, :class => Component do
    name "Folder1"
    is_root false
  end

  factory :bad, :class => Component do |cl|
    cl.name ""
    cl.is_root false
  end
end
