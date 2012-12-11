FactoryGirl.define do
  factory :user do
    first_name "Administrator"
    last_name  "Projestimate"
    login_name "admin"
    initials   "ad"
    email      "youremail@yourcompany.net"
    auth_method
    user_status "active"
    language
    password   "projestimate"
    password_confirmation "projestimate"
  end

  factory :auth_method do  |auth|
    auth.name "Application"
    auth.server_name "not Necessary"
    auth.port 0
    auth.base_dn "Not necessary"
    auth.user_name_attribute nil
    auth.certificate 0
    auth.scope nil
  end

  factory :language do
    name "English"
    locale "en"
  end


  # Projects
  factory :project do |p|
    p.title "Projet1"
    p.description "Projet N1"
    p.alias "P1"
    p.state "Preliminary"
    p.start_date Time.now
  end


  # Organizations
  factory :organization do
    name "Organisation1"
    description "Organisation number 1"
  end


  # Components
  factory :component do
    name "Root compoment"
    is_root true
    wbs
  end

  #component as folder
  factory :component_folder, :class => Component do |cf|
    name "Folder_1"
    #work_element_type_folder
    cf.association :work_element_type, :factory => work_element_type_folder
  end

  #component as link
  factory :component_link, :class => Component do |cl|
    cl.name "Link_1"
    cl.association :work_element_type, :factory => work_element_type_link
  end

  #Wbs
  factory :wbs do
    project
  end

  factory :wbs_1, class: Wbs do
  end


  #WorkElementType
  factory :work_element_type_folder , :class => WorkElementType do |wet|
    wet.name "Folder"
    wet.alias "folder"
    wet.association :peicon, :factory => :peicon_folder
  end

  factory :work_element_type_link , :class => WorkElementType do |wet|
    wet.name "Link"
    wet.alias "link"
    wet.association :peicon, :factory => :peicon_link
  end


  # Peicon
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


  # Attributes
  factory :ksloc_attribute, :class => Attribute do |attr|
    attr.name "Ksloc1"
    attr.alias "ksloc1"
    attr.description "Attribut number 1"
    attr.attr_type "Integer"
  end


  #Pemodule
  #factory :pemodule do |mo|
  #  mo.title "Cocomo basic"
  #  mo.alias "cocomo_basic"
  #  mo.description "cocomo très basic"
  #end

end