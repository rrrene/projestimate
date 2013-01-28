FactoryGirl.define do

  #factory :folder, :class => Component do |cl|
  #  cl.name "Folder1"
  #  cl.is_root false
  #  cl.association :work_element_type#, :factory =>  :work_element_type_folder
  #end

  #factory :pbs_project_element do
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

  factory :folder, :class => PbsProjectElement do
    name "Folder1"
    is_root false
  end

  factory :bad, :class => PbsProjectElement do |cl|
    cl.name ""
    cl.is_root false
  end
end
