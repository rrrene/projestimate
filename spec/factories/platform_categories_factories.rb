# Platform Category
FactoryGirl.define do

  factory :platform_category do
    name  "Test"
    description  "TBD"
  end


  factory :unknown_platform_category, :class => PlatformCategory do
    name  "Unknown"
    description  "TBD"
  end
#
#  factory :client_server_platform_category, :class => PlatformCategory do
#    name  "Client-Server"
#    description  "TBD"
#  end
#
#  factory :mobile_ground_based_platform_category, :class => PlatformCategory do
#    name  "Mobile Ground-Based"
#    description  "TBD"
#  end
#
#  factory :server_platform_category, :class => PlatformCategory do
#    name  "Server"
#    description  "TBD"
#  end
#
#  factory :telecommunications_platform_category, :class => PlatformCategory do
#    name  "Telecommunications"
#    description  "TBD"
#  end
#
#  factory :web_base_dev_platform_category, :class => PlatformCategory do
#    name  "Web Based Development"
#    description  "TBD"
#  end
#
end
