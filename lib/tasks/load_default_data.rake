#encoding: utf-8
#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012 Spirula (http://www.spirula.fr)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
########################################################################


namespace :projestimate do
  desc "Load default data"
  task :load_default_data => :environment do

    print "\n You're about to install the default data on #{Rails.env} database. Do you want : \n
       1- Delete all data then reinstall default data -- Press 1 \n
       2- Reinstall default data and keep old data (recommended) -- Press 2 \n
       3- Do nothing and quit the prompt -- Press 3 or Ctrl + C \n
    \n"

    i = true
    while i do
      STDOUT.flush
      response = STDIN.gets.chomp!

      if response == '1'
        are_you_sure? do
          puts "Deleting all data...\n"
          MasterSetting.delete_all
          ProjectArea.delete_all
          ProjectCategory.delete_all              
          PlatformCategory.delete_all             
          AcquisitionCategory.delete_all
          Attribute.delete_all
          Pemodule.delete_all
          AttributeModule.delete_all
          WorkElementType.delete_all          
          ProjectSecurityLevel.delete_all 
          Permission.delete_all
          Currency.delete_all             
          Language.delete_all 
                             
          AdminSetting.delete_all
          User.delete_all
          Group.delete_all
          
          Organization.delete_all
          #Inflation.delete_all 
          OrganizationLaborCategory.delete_all         
              
          ActivityCategory.delete_all
                
          LaborCategory.delete_all
          
          AttributeModule.delete_all
          Project.delete_all
          #ProjectUser.delete_all
          Wbs.delete_all
          ModuleProject.delete_all
          ModuleProjectAttribute.delete_all

          Component.delete_all
          

          load_data!
        end
        i = false
      elsif response == '2'
        are_you_sure? do
          load_data!
        end
        i = false
      elsif response == '3'
        puts "Nothing to do. Bye."
        i = false
      end
    end
  end
end

private
def load_data!
  begin
    
  puts " Creating Master Parameters ..."

    puts "   - Master setting"
    #Create master/admin setting
    MasterSetting.create(:key => "url_wiki", :value => "http://projestimate.org/projects/pe/wiki")
    MasterSetting.create(:key => "url_service", :value => "http://projestimate.org/projects/pe/wiki/Community_Services")

    puts "   - Project areas"
    #Default project area
    ProjectArea.create(:name => "SW Project", :description => "Software")
    pjarea=ProjectArea.first

    puts "   - Project categories"
    ProjectCategory.create(:name => "Unknown", :description => "TBD")
    pjcategory=ProjectCategory.first
    ProjectCategory.create(:name => "Mulimedia", :description => "TBD")
    ProjectCategory.create(:name => "Network Management", :description => "TBD")
    ProjectCategory.create(:name => "Office Automation", :description => "TBD")
    ProjectCategory.create(:name => "Relational Database", :description => "TBD")
    ProjectCategory.create(:name => "Report Generation", :description => "TBD")
    ProjectCategory.create(:name => "System & Device Utilities", :description => "TBD")
    ProjectCategory.create(:name => "Transaction Processing", :description => "TBD")
    ProjectCategory.create(:name => "Robotics", :description => "TBD")
    ProjectCategory.create(:name => "Simulation", :description => "TBD")
    ProjectCategory.create(:name => "Software Development Tools", :description => "TBD")
    ProjectCategory.create(:name => "Workflow", :description => "TBD")

    puts "   - Platform categories"
    PlatformCategory.create(:name => "Unknown", :description => "TBD")
    plcategory=PlatformCategory.first    
    PlatformCategory.create(:name => "Client-Server", :description => "TBD")
    PlatformCategory.create(:name => "Mobile Ground-Based", :description => "TBD")
    PlatformCategory.create(:name => "Server", :description => "TBD")
    PlatformCategory.create(:name => "Telecommunications", :description => "TBD")
    PlatformCategory.create(:name => "Web Based Development", :description => "TBD")
    
    puts "   - Acquisition categories"
    #Default acquisition category
      acquisition_category = Array.new
      acquisition_category = [
        ["Unknown","TBD"],
        ["New Development","TBD"],
        ["Enhancement","TBD"],
        ["Re-development","TBD"],
        ["POC","TBD"],
        ["Purchased","TBD"],
        ["Porting","TBD"],
        ["Other","TBD"]
      ]

      acquisition_category.each do |i|
        AcquisitionCategory.create(:name => i[0], :description => i[1])
      end
      accategory=AcquisitionCategory.first
      
    puts "   - Attributes"
      attributes = [
      ["KSLOC", "ksloc", "Kilo Size Line Of Code.", "integer", [], "sum"],
      ["Cost", "cost", "Cost of a product, a service or a processus.", "integer", [], "sum"],
      ["Delay", "delay", "Time allowed for the completion of something.", "integer", [], "average"],
      ["Staffing", "staffing", "Staff required to accomplish a task", "integer", [], "sum"],
      ["Staffing complexity", "staffing_complexity", "A rating of the project's inherent difficulty in terms of the rate at which staff are added to a project.", "integer", [], "average"],
      ["Effective technology", "effective_technology", "A composite metric that captures factors relating to the efficiency or productivity with which development can be carried out.", "integer", [], "average"],
      ["End date", "end_date", "End date for a task, a component. Dependent of delay.", "date", [], "maxi"], 
      ["Effort", "effort", "Effort in Man-Months", "integer", [], "average"],
      ["Duration", "duration", "Duration of a task", "integer", [], "average"],
      ["Complexity", "complexity", "Application complexity (for COCOMO modules)", "integer", [], "average"],
    ]

    attributes.each do |i|
      Attribute.create(:name => i[0], :alias => i[1], :description => i[2], :attr_type => i[3], :options => i[4], :aggregation => i[5])
    end

    puts "   - Modules"
    Pemodule.create(:title => "cocomo_basic", :alias => "cocomo_basic", :description => "TBD")

    puts "   - WBS structure"
    #Create first work element type (type of a component)
    WorkElementType.create(:name => "Folder", :alias => "folder")
    WorkElementType.create(:name => "Link", :alias => "link")
    WorkElementType.create(:name => "Undefined", :alias => "undefined")
    WorkElementType.create(:name => "Developed Software", :alias => "DevSW")
    WorkElementType.create(:name => "Purchased Software", :alias => "$SW")
    WorkElementType.create(:name => "Purchased Hardware", :alias => "$HW")
    WorkElementType.create(:name => "Purchased Miscellaneous", :alias => "$SMisc")

    wet = WorkElementType.first
           
    puts "   - Currencies"
    # First need to fix Currency.delete_all 
    Currency.create(:name => "Euro", :alias => "EUR", :description => "TBD" )
    Currency.create(:name => "US Dollar", :alias => "USD", :description => "TBD" )
    Currency.create(:name => "British Pound", :alias => "GBP", :description => "TBD" ) 
    
    puts "   - Language..."
    #Create default language
    Language.create(:name => "English", :locale => "en")
    Language.create(:name => "Français", :locale => "fr")


  puts " Creating Admin Parameters ..."
    
    puts "   - Admin setting"    
    AdminSetting.create(:key => "welcome_message", :value => "Welcome aboard !")
    AdminSetting.create(:key => "notifications_email", :value => "AdminEmail@domaine.com")

    puts "   - Auth Method"
    AuthMethod.create(:name => "Application", :server_name => "Not necessary", :port => 0, :base_dn => "Not necessary", :certificate => "none")
    
    puts "   - Admin user"
    #Create first user
    User.create(:first_name => "Administrator", :surename => "Projestimate", :user_name => "admin", :initials => "ad", :email => "youremail@yourcompany.net", :auth_type => AuthMethod.first.id, :user_status => "active", :language_id => Language.first.id)
    user = User.first
    user.password = "projestimate"
    user.save
    
    puts "   - Default groups"
    #Create default groups
    Group.create(:name => "MasterAdmin")
    Group.create(:name => "Admin")
    Group.create(:name => "Everyone")
    #Associated default user with group MasterAdmin
    user.group_ids = [Group.first.id]
    user.save

    puts "   - Labor categories"
    #Default labor category
      array_labor_category = Array.new
      array_labor_category = [
        ["Director","TBD"],
        ["Manager","TBD"],
        ["Programm Manager","TBD"],
        ["Administrator","TBD"],
        ["Project Manager","TBD"],
        ["Team leader","TBD"],
        ["Consultant","TBD"],
        ["Analyst","TBD"],
        ["System Analyst","TBD"],
        ["Architect","TBD"],
        ["Computer Programmer","TBD"],
        ["Trainer","TBD"],
        ["Technician","TBD"],
        ["Operator","TBD"],
        ["Support Agent","TBD"],
        ["Document writer","TBD"],
        ["Test Agent","TBD"]
      ]

      array_labor_category.each do |i|
        LaborCategory.create(:name => i[0], :description => i[1])
      end
      laborcategory=LaborCategory.first

    puts "   - Activity categories"
    #Default actitity category
    array_activity_category =  Array.new
    array_activity_category = [
              ["Acquisition activities", "Acquisition", "Acquisition covers the activities involved in initiating a project"],
              ["Supply activities", "Supply", "Supply covers the activities involved to develop a project management plan"],
              ["Development / Define Functional requirements","Requirements","Gather the functional requirements, or demands, for the product that is to be created."],
              ["Development / Create High level Design","Design","A basic layout of the product is created. This means the setup of different modules and how they communicate with each other. This design does not contain very much detail about the modules."],
              ["Development / Create Module design","Detailed design","The different modules present in the High level design are designed separately. The modules are designed in as much detail as possible"],
              ["Development / Coding","Coding","The code is created according to the high level design and the module design."],
              ["Development / Module test","Module test","The different modules are tested for correct functioning. If this is the case the project can move to the next activity, else the project returns to the module design phase to correct any errors."],
              ["Development / Integration test","Integration test","The communication between modules is tested for correct functioning. If this is the case the project can move to the next activity, else the project falls back to the high level design to correct any errors."],
              ["Development / System test","System test","This test checks whether all functional requirements are present in the product. If this is the case the product is completed and the product is ready to be transferred to the customer. Else the project falls back to the software requirements activity and the functional requirements have to be adjusted."],
              ["Operation","Operation","The operation and maintenance phases occur simultaneously, the operation-phase consists of activities like assisting users in working with the created software product."],
              ["Maintenance","Maintenance","The maintenance-phase consists of maintenance-tasks to keep the product up and running. The maintenance includes any general enhancements, changes and additions, which might be required by the end-users. These defects and deficiencies are usually documented by the developing organization to enable future solutions and known issues addressing in any future maintenance releases. There is no disposal phase"],
              ["Documentation","TBD","TBD"],
              ["Configuration Management","TBD","TBD"],
              ["Quality management","TBD","TBD"],
              ["Management","TBD","TBD"],
              ["Training","TBD","TBD"],
              ["Distribution","TBD","TBD"],
              ["Other","TBD","TBD"]
            ]
      array_activity_category.each do |i|
        ActivityCategory.create(:name => i[0], :alias => i[1], :description => i[2])
      end
    
  puts " Creating  organizations..."
    Organization.create(:name => "YourOrganization", :description => "This must be update to match your organization")
    organization = Organization.first
    Organization.create(:name => "Other", :description => "This could be used to group users that are not members of any orgnaization")

    #puts "   - Inflation"
    #Inflation.create(:organization_id => organization.id, :year => Time.now.strftime("%Y"), :labor_inflation => "1.0", :material_inflation => "1.0", :description => "TBD" )
    
    #puts "   - Organization Labor Category"
    #OrganizationLaborCategory.create(:labor_category_id => laborcategory, :organization_id => organisation, :name=laborcategory.name)    
    
  puts " Creating Samples data ..."

    puts "   - Demo project"
    #Create default project
    Project.create(:title => "Sample project", :description => "This is a sample project for demonstration purpose", :alias => "sample project", :state => "preliminary", :start_date => Time.now.strftime("%Y/%m/%d"), :is_model => false, :organization_id => organization.id, :project_area_id => pjarea.id, :project_category_id => ProjectCategory.first.id, :platform_category_id => PlatformCategory.first.id, :acquisition_category_id =>  AcquisitionCategory.first.id)
    project = Project.first
    #Associated default user with sample project     
    user.project_ids = [Project.first.id]
    user.save
    #Create default wbs associated with previous project
    Wbs.create(:project_id => project.id)
    wbs = Wbs.first
    #Create root component
    component = Component.create(:is_root => true, :wbs_id => wbs.id, :work_element_type_id => wet.id, :position => 0, :name => "Root folder")
    component = Component.first

    puts "Create project security level..."
    #Default project Security Level
    project_security_level = ["FullControl","Define","Modify","Comment","ReadOnly"]
    project_security_level.each do |i|
      ProjectSecurityLevel.create(:name => i)
    end

    puts "Create global permissions..."
    #Default permissions
    permissions= [ ["edit_own_profile", "Edit your own profile", false],
                   ["validate_user_account", "Validate user accounts", false],
                   ["edit_user_account_no_admin", "Editing user accounts (except Admin and MasterAdmin accounts)", false],
                   ["edit_account_super_admin", "Editing Admin and MasterAdmin accounts", false],
                   ["edit_account_admin", "Editing Admin accounts (but not MasterAdmin accounts)", false],
                   ["edit_groups", "Editing groups", false],
                   ["manage_permissions", "Manage (all) permissions", true],
                   ["manage_specific_permissions", "Manage project permissions", false],
                   ["manage_project_area", "Manage Project Area", false],
                   ["manage_currency", "Manage Currency", false],
                   ["manage_organizations", "Manage Organizations", false],
                   ["manage_labor_categories", "Manage Labor Categories", false],
                   ["manage_event_types", "Manage Event types", true],
                   ["manage_project_categories", "Manage Projct Categories", false],
                   ["manage_platform_categories", "Manage Platform Categories", false],
                   ["manage_acquisition_categories", "Manage Acquisition Categories", false],
                   ["manage_wet", "Manage Work Element Types", false],
                   ["manage_attributes", "Manage Attributes", false],
                   ["manage_modules", "Manage Modules", false],
                   ["manage_activity_categories", "Manage Activity Categories", false],
                   ["manage_help_messages", "Manage Help message", false],
                   ["edit_languages", "Manage languages of the application", false],
                   ["access_to_admin", "Access to administration page", false],
                   ["create_new_project", "Create new project", false],
                   ["delete_a_project", "Delete project", true],
                   ["edit_a_project", "Edit project", true],
                   ["modify_a_project", "Modifier un projet", true],
                   ["access_to_a_project", "Access to project", true],
                   ["list_project", "View the list of Project (project index)", true],
                   ["add_a_component", "Add a Component", true],
                   ["delete_a_component", "Delete Component", true],
                   ["move_a_component", "Move Component", true],
                   ["edit_a_component", "Edit Component", true],
                   ["access_to_a_component", "Access Component", true],
                   ["add_a_module_to_a_process", "Add Mdoule to project estimation process", true],
                   ["delete_a_module_project", "Delete a project module", true],
                   ["move_a_module_project", "Move a project module", true],
                   ["edit_a_module_project", "Edit a project module", true],
                   ["run_estimation_process", "Run an estimation process", true],
                   ["access_to_a_module", "Access Modules", true],
                   ["add_an_attribute", "Add attribute", true],
                   ["delete_an_attribute", "Delete Attribute", true],
                   ["edit_an_attribute", "Edit Attribute", true],
                   ["access_to_attributes", "Access to Attributes", true],
                   ["edit_own_profile_security", "Edit profile security", false]
                  ]

    permissions.each do |i|
      Permission.create(:name => String.keep_clean_space(i[0]), :description => i[1], :is_permission_project => i[2])
    end

    puts "\n\n"
    puts "Default data was successfully loaded. Enjoy !"
  rescue Errno::ECONNREFUSED
    puts "\n\n\n"
    puts "!!! WARNING - Error: Default data was not loaded, please investigate"
    puts "Maybe run bundle exec rake sunspot:solr:start RAILS_ENV=your_environnement"
  rescue Exception
    puts "\n\n"
    puts "!!! WARNING - Exception: Default data was not loaded, please investigate"
    puts "Maybe run db:create and db:migrate tasks."
  end
end


def are_you_sure?(&block)
  j = true
  while j do
    puts "Are you sure do you continue (Y or N) ? : "
    STDOUT.flush
    res = STDIN.gets.chomp!
    if res == "Y" or res == "y"
      block.call
      j = false
    elsif res == "N" or res == "n"
      puts "Nothing to do. Bye."
      j = false
    else
      puts "Incorrect answer"
      j = true
    end
  end
end