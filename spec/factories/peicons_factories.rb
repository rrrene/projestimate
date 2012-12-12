# Projestimate Icons

FactoryGirl.define do

  factory :peicon_folder, :class => Peicon do
    name "Folder"
    icon_file_name "myFolder"
    icon_content_type "image/png"
    icon_file_size 500
  end

  factory :peicon_link, :class => Peicon do
    name "Link"
    icon_file_name "myLink"
    icon_content_type "image/png"
    icon_file_size 506
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
#
#  @folder_icon = FactoryGirl.create(:folder_icon)
#  @link_icon = FactoryGirl.create(:link_icon)
#  @undefined_icon = FactoryGirl.create(:undefined_icon)
#  @default_icon = FactotyGirl.create(:default_icon)
#
end
