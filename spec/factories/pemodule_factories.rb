#
FactoryGirl.define do

  #Pemodule
  factory :pemodule do |mo|
    mo.sequence(:title) {|n| "Cocomo basic_#{n}" }
    mo.sequence(:alias) {|n| "cocomo_basic_#{n}" }
    mo.description "basic cocomo"
    mo.uuid { uuid }
    mo.association :record_status, :factory => :proposed_status, strategy: :build
  end

end




#    # ModuleProject
#    #factory :module_project_save, :class => ModuleProject do |mp|
#    #  mp.association :pemodule, factory => :pemodule
#    #  mp.association :project, factory => :project
#    #  mp.position_x { |x| x.position_x = FactoryGirl.next(:position_x) }
#    #  mp.position_y { |y| y.position_y = FactoryGirl.next(:position_y)}
#    #end
#    #
#    #factory :module_project_save, :class => ModuleProject do |mp|
#    #  mp.association :pemodule, factory => :pemodule
#    #  mp.association :project, factory => :project
#    #  mp.position_x { |x| x.position_x = FactoryGirl.next(:position_x) }
#    #  mp.position_y { |y| y.position_y = FactoryGirl.next(:position_y)}
#    #end
#
#    factory :module_project1, :class => ModuleProject do |mp|
#      #mp.association :pemodule, factory => :pemodule
#      #mp.association :project, factory => :pe_project
#      mp.position_x 1
#      mp.position_y 1
#    end
#
#    #factory :module_project2, :class => ModuleProject do |mp|
#    #  #mp.association :pemodule, factory => :pemodule
#    #  #mp.association :project, factory => :pe_project
#    #  mp.position_x 1
#    #  mp.position_y 2
#    #end
#
#    #factory sequence(:module_project) { |mp| "module_project#{n}"}, :class => ModuleProject do
#    #  mp.association :pemodule, factory => :pemodule
#    #  mp.association :project, factory => :project
#    #  mp.position_x { |x| x.position_x = FactoryGirl.next(:position_x) }
#    #  mp.position_y { |y| y.position_y = FactoryGirl.next(:position_y)}
#    #end
#

