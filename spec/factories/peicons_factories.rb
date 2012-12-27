# Projestimate Icons

FactoryGirl.define do

  factory :peicon do

    association :record_status, :factory => :proposed_status, strategy: :build

    trait :ifolder do
      sequence(:name) {|n| "Folder_#{n}"}
      icon_file_name "myFolder"
      icon_content_type "image/png"
      icon_file_size 500
      uuid
    end

    trait :ilink do
      sequence(:name) {|n| "Link_#{n}"}
      icon_file_name "myLink"
      icon_content_type "image/png"
      icon_file_size 506
      uuid
    end

    factory :peicon_folder do
      ifolder
    end

    factory :peicon_link do
      ilink
    end

  #
  #  factory :folder_icon, :class => Peicon do
  #    name "Folder"
  #    icon File.new("#{Rails.root}/public/folder.png", "r")
  #  end
  #
  #  factory :link_icon, :class => Peicon do
  #    name "Link"
  #    icon File.new("#{Rails.root}/public/link.png", "r")
  #  end
  #
  #  factory :undefined_icon, :class => Peicon do
  #    name "Undefined"
  #    icon  File.new("#{Rails.root}/public/undefined.png", "r")
  #  end
  #
  #  factory :default_icon, :class => Peicon do
  #    name "Default"
  #    icon File.new("#{Rails.root}/public/default.png", "r")
  #  end

  end
end
