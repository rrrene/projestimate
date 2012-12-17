## Work Element Types
#
FactoryGirl.define do
  #
  #factory :folder_wet, :class => WorkElementType do |wet|
  #  wet.name        "Folder"
  #  wet.alias        "folder"
  #end
#
#  factory :link_wet, :class => WorkElementType do |wet|
#    wet.name        "Link"
#    wet.alias       "link"
#    wet.association :peicon, :factory => :link_icon
#  end
#
#  factory :undefined_wet, :class => WorkElementType do |wet|
#    wet.name        "Undefined"
#    wet.alias       "undefined"
#    wet.association :peicon, :factory => :undefined_icon
#  end
#
#  factory :default_wet, :class => WorkElementType do |wet|
#    wet.name        "Default"
#    wet.alias       "default"
#    wet.association :peicon, :factory => :default_icon
#  end
#
#  factory :developed_software_wet, :class => WorkElementType do |wet|
#    wet.name        "Developed Software"
#    wet.alias       "DevSW"
#    wet.association :peicon, :factory => :default_icon
#  end
#
#  factory :purchased_software_wet, :class => WorkElementType do |wet|
#    wet.name        "Purchased Software"
#    wet.alias       "$SW"
#    wet.association :peicon, :factory => :default_icon
#  end
#
#  factory :default_wet, :class => WorkElementType do |wet|
#    wet.name        "Purchased Hardware"
#    wet.alias       "$HW"
#    wet.association :peicon, :factory => :default_icon
#  end
#
#  factory :misc_wet, :class => WorkElementType do |wet|
#    wet.name        "Purchased Miscellaneous"
#    wet.alias       "$Misc"
#    wet.association :peicon, :factory => :default_icon
#  end

  factory :work_element_type , :class => WorkElementType do |wet|
    wet.name "wet"
    wet.alias "wet"

    trait :wet_folder do  |wetf|
      wetf.name "Folder1"
      wetf.alias "folder"
    end

    trait :wet_link do |wetl|
      wetl.name "Link"
      wetl.alias "link"
    end
  end

end

