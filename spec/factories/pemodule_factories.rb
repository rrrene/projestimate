# FactoryGirl.define do
##    #
##    #sequence :position_x do |n|
##    #  n
##    #end
##    #
##    #sequence :position_y do |n|
##    #  n
##    #end
##
#    #Pemodule
#    factory :pemodule do |mo|
#      mo.title "Cocomo basic"
#      mo.alias "cocomo_basic"
#      mo.description "cocomo très basic"
#    end
#
#    #Project
#    factory :pe_project, :class => Project do |p|
#      p.title "pe_projet_1"
#      p.description "PE Projet n1"
#      p.alias "PE_P1"
#      p.state "Preliminary"
#      p.start_date Time.now
#    end
##
##
##    # ModuleProject
##    #factory :module_project_save, :class => ModuleProject do |mp|
##    #  mp.association :pemodule, factory => pemodule
##    #  mp.association :project, factory => project
##    #  mp.position_x { |x| x.position_x = FactoryGirl.next(:position_x) }
##    #  mp.position_y { |y| y.position_y = FactoryGirl.next(:position_y)}
##    #end
##    #
##    #factory :module_project_save, :class => ModuleProject do |mp|
##    #  mp.association :pemodule, factory => pemodule
##    #  mp.association :project, factory => project
##    #  mp.position_x { |x| x.position_x = FactoryGirl.next(:position_x) }
##    #  mp.position_y { |y| y.position_y = FactoryGirl.next(:position_y)}
##    #end
##
#    factory :module_project1, :class => ModuleProject do |mp|
#      #mp.association :pemodule, factory => pemodule
#      #mp.association :project, factory => pe_project
#      mp.position_x 1
#      mp.position_y 1
#    end
##
##    #factory :module_project2, :class => ModuleProject do |mp|
##    #  #mp.association :pemodule, factory => pemodule
##    #  #mp.association :project, factory => pe_project
##    #  mp.position_x 1
##    #  mp.position_y 2
##    #end
##
##    #factory sequence(:module_project) { |mp| "module_project#{n}"}, :class => ModuleProject do
##    #  mp.association :pemodule, factory => pemodule
##    #  mp.association :project, factory => project
##    #  mp.position_x { |x| x.position_x = FactoryGirl.next(:position_x) }
##    #  mp.position_y { |y| y.position_y = FactoryGirl.next(:position_y)}
##    #end
##
#end
