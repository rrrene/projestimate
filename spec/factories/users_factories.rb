# User

FactoryGirl.define do

  factory :user2, :class => :user do
    first_name "Administrator2"
    last_name  "Projestimate2"
    login_name "admin2"
    email      "admin2@yourcompany.net"
    initials   "ad2"
    auth_method
    user_status "active"
    language
    password   "projestimate2"
    password_confirmation "projestimate2"
  end

  factory :user3, :class => :user do
    first_name "Administrator3"
    last_name  "Projestimate3"
    login_name "admin3"
    email      "admin3@yourcompany.net"
    initials   "ad3"
    auth_method
    user_status "active"
    language
    password   "projestimate3"
    password_confirmation "projestimate3"
  end

#  factory :user do
#
#    #factory :admin_user do
#      first_name    "Administrator"
#      last_name     "Projestimate"
#      login_name    "admin1"
#      password      "projestimate"
#      password_confirmation "projestimate"
#      initials      "ad"
#      email         "youremail1@yourcompany.net"
#      auth_method
#      user_status   "active"
#      #association   :language
#    #end
#  end
#
#  factory :auth_method do
#    name  "Application"
#    server_name "Not necessary"
#    port 0
#    base_dn "Not necessary"
#    certificate  "false"
#  end
#
end
