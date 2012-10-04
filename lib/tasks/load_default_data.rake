#encoding: utf-8
namespace :projestimate do
  desc "Load default data"
  task :load_default_data => :environment do

    puts "Please wait..."

    #TODO: ask if user want delete old files
    #Delete old data.
    ActivityCategory.delete_all
    Attribute.delete_all
    AttributeModule.delete_all
    LaborCategory.delete_all
    AcquisitionCategory.delete_all
    User.delete_all
    Language.delete_all
    Project.delete_all
    Wbs.delete_all
    Group.delete_all
    WorkElementType.delete_all
    Component.delete_all
    AdminSetting.delete_all
    MasterSetting.delete_all
    Permission.delete_all
    ProjectSecurityLevel.delete_all
    ProjectArea.delete_all
    Organization.delete_all
    Pemodule.delete_all
    ModuleProject.delete_all
    ModuleProjectAttribute.delete_all

    begin

      puts "Create default language..."
      #Create default language
      Language.create(:name => "Français", :locale => "fr")

      puts "Create demo project..."
      #Create default project
      Project.create(:title => "Your first project", :description => "Description of your first project", :alias => "project", :state => "open", :start_date => Time.now, :is_model => true)
      project = Project.first

      puts "Create demo project wbs..."
      #Create default wbs associated with previous project
      Wbs.create(:project_id => project.id)
      wbs = Wbs.first

      puts "Create WBS structure..."
      #Create first work element type (type of a component)
      WorkElementType.create(:name => "Folder", :alias => "folder")
      WorkElementType.create(:name => "Development", :alias => "development")
      WorkElementType.create(:name => "Commercial off-the-shelf", :alias => "cots")
      WorkElementType.create(:name => "Link", :alias => "link")
      WorkElementType.create(:name => "Undefined", :alias => "undefined")
      wet = WorkElementType.first

      #Create root component
      component = Component.create(:is_root => true, :wbs_id => wbs.id, :work_element_type_id => wet.id, :position => 0, :name => "Root folder")
      component = Component.first

      puts "Create admin user..."
      #Create first user
      User.create(:first_name => "admin", :surename => "admin", :user_name => "admin", :initials => "ad", :email => "nicolas.renard@spirula.fr", :type_auth => "app", :user_status => "active")
      user = User.first
      user.password = "projestimate"
      user.language = Language.first
      user.save

      puts "Create default groups..."
      #Creat default groups
      group_array = Array.new
      group_array = [
                      ["SuperAdmin"],
                      ["Admin"],
                      ["Everyone"]
                    ]

      group_array.each do |i|
        Group.create(:name => i[0])
      end

     #Associated default user with group SuperAdmin
     user.group_ids = [Group.first.id]
     user.save

     user.project_ids = [Project.first.id]
     user.save

      puts "Create activity categories..."
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
                ["Documentation","",""],
                ["Configuration Management","",""],
                ["Quality management","",""],
                ["Management","",""],
                ["Training","",""],
                ["Distribution","",""],
                ["Other","",""]
              ]
        array_activity_category.each do |i|
          ActivityCategory.create(:name => i[0], :alias => i[1], :description => i[2])
        end

      puts "Create labor categories..."
      #Default labor category
        array_labor_category = Array.new
        array_labor_category = [
          ["Director",""],
          ["Manager",""],
          ["Programm Manager",""],
          ["Administrator",""],
          ["Project Manager",""],
          ["Team leader",""],
          ["Consultant",""],
          ["Analyst",""],
          ["System Analyst",""],
          ["Architect",""],
          ["Computer Programmer",""],
          ["Trainer",""],
          ["Technician",""],
          ["Operator",""],
          ["Support Agent",""],
          ["Document writer",""],
          ["Test Agent",""]
        ]

        array_labor_category.each do |i|
          LaborCategory.create(:name => i[0], :description => i[1])
        end

      puts "Create acquisition categories..."
      #Default acquisition category
        acquisition_category = Array.new
        acquisition_category = [
          ["Not Defined",""],
          ["New Development",""],
          ["Enhancement",""],
          ["Re-development",""],
          ["POC",""],
          ["Purchased",""],
          ["Porting",""],
          ["Other",""]
        ]

        acquisition_category.each do |i|
          AcquisitionCategory.create(:name => i[0], :description => i[2])
        end

      puts "Load default setting..."
      #Create master/admin setting
      MasterSetting.create(:key => "url_wiki", :value => "http://vps13831.ovh.net:3000/projects/projestimate/wiki")
      MasterSetting.create(:key => "url_service", :value => "http://vps13831.ovh.net:3000/projects/projestimate/wiki")
      AdminSetting.create(:key => "welcome_message", :value => "Welcome aboard !")
      AdminSetting.create(:key => "notifications_email", :value => "renard760@gmail.com")

      puts "Create project security level..."
      #Default project Security Level
      project_security_level = ["FullControl","Define","Modify","Comment","ReadOnly"]
      project_security_level.each do |i|
        ProjectSecurityLevel.create(:name => i)
      end

      puts "Create project areas..."
      #Default project area
      ProjectArea.create(:name => "Software")

      puts "Create global permissions..."
      #Default permissions
      permissions= [ ["edit_own_profile", "Editer son profil", false],
                     ["validate_user_account", "Valider les comptes utilisateur\r\n", false],
                     ["edit_user_account_no_admin", "Editer les comptes utilisateurs (non admin)", false],
                     ["edit_account_super_admin", "Editer les comptes SuperAdmin", false],
                     ["edit_account_admin", "Editer les comptes Admin", false],
                     ["edit_groups", "Editer les groupes", false],
                     ["manage_permissions", "Gérer toutes les permissions", true],
                     ["manage_specific_permissions", "Gérer les permissions spécifiques à un projet", false],
                     ["manage_project_area", "Gérer les Domaines de projet", false],
                     ["manage_currency", "Gérer les Monnaies", false],
                     ["manage_organizations", "Gérer les Organisations", false],
                     ["manage_labor_categories", "Gérer les catégories de Travailleurs", false],
                     ["manage_event_types", "Gérer les type d'evenement", true],
                     ["manage_project_categories", "Gérer les Catégories de projet", false],
                     ["manage_platform_categories", "Gérer les catégories de Platformes", false],
                     ["manage_acquisition_categories", "Gérer les catégories d'acquisition", false],
                     ["manage_wet", "Gérer les Work Element Type", false],
                     ["manage_attributes", "Gérer les attributs", false],
                     ["manage_modules", "Gérer les modules", false],
                     ["manage_activity_categories", "Gérer les Catégories d'activités", false],
                     ["view_help", "Acceder à l'aide", false],
                     ["manage_help_messages", "Gérer les messages d'aide", false],
                     ["edit_languages", "Manage languages of the application", false],
                     ["access_to_admin", "Access to administration page", false],
                     ["create_new_project", "Créer un nouveau projet", false],
                     ["delete_a_project", "Supprimer un projet", true],
                     ["edit_a_project", "Editer un projet", true],
                     ["modify_a_project", "Modifier un projet", true],
                     ["access_to_a_project", "Accéder à un projet", true],
                     ["list_project", "Lister un projet (index des projets)", true],
                     ["add_a_component", "Ajouter un composant", true],
                     ["delete_a_component", "Supprimer un composant", true],
                     ["move_a_component", "Déplacer un composant", true],
                     ["edit_a_component", "Editer un composant", true],
                     ["access_to_a_component", "Accéder à un composant", true],
                     ["add_a_module_to_a_process", "Ajouter un module au processus d’estimation du projet", true],
                     ["delete_a_module_project", "Supprimer un module project", true],
                     ["move_a_module_project", "Déplacer un module project", true],
                     ["edit_a_module_project", "Editer un module", true],
                     ["run_estimation_process", "Exécuter un processus d'estimation", true],
                     ["access_to_a_module", "Accéder aux modules", true],
                     ["add_an_attribute", "Ajouter un attribut", true],
                     ["delete_an_attribute", "Supprimer un attribut", true],
                     ["edit_an_attribute", "Editer un attribut", true],
                     ["access_to_attributes", "Accéder aux attributs projets", true],
                     ["edit_own_profile_security", "Editer tous les droits", false],
                     ["edit_faq", "Editer la Faq", false]
                    ]

      permissions.each do |i|
        Permission.create(:name => String.keep_clean_space(i[0]), :description => i[1], :is_permission_project => i[2])
      end

      puts "Create default organizations..."
      Organization.create(:name => "Spirula", :description => "Estimation et mesure")
      Organization.create(:name => "Banque de France", :description => "...")
      Organization.create(:name => "PSA Citroen", :description => ":)")
      Organization.create(:name => "Autre", :description => "nothing to do")

      attributes = [
        ["KSLOC", "ksloc", "Kilo Size Line Of Code.", "0", [], "sum"],
        ["Cost", "cost", "Cost of a product, a service or a processus.", "0", [], "sum"],
        ["Delay", "delay", "Time allowed for the completion of something.", "0", [], "average"],
        ["Staffing", "staffing", "Staff required to accomplish a task", "0", [], "sum"],
        ["Staffing complexity", "staffing_complexity", "A rating of the project's inherent difficulty in terms of the rate at which staff are added to a project.", "0", [], "average"],
        ["Effective technology", "effective_technology", "A composite metric that captures factors relating to the efficiency or productivity with which development can be carried out.", "0", [], "average"],
        ["End date", "end_date", "End date for a task, a component. Dependent of delay.", "2", [], "maxi"], ["Effort", "effort", "Effort in Man-Months", "0", [], "average"],
        ["Duration", "duration", "Duration of a task", "0", [], "average"],
        ["Complexity", "complexity", "Application complexity (for COCOMO modules)", "0", [], "average"],
      ]

      puts "Create default attributes..."
      attributes.each do |i|
        Attribute.create(:name => i[0], :alias => i[1], :description => i[2], :attr_type => i[3], :options => i[4], :aggregation => i[5])
      end
    rescue Errno::ECONNREFUSED
      puts "\n\n\n"
      puts "Default data was not loaded."
      puts "Please run bundle exec rake sunspot:solr:start RAILS_ENV=your_environnement"
    rescue Exception
      puts "\n\n\n"
      puts "Default data was not loaded."
      puts "Maybe run db:create and db:migrate tasks."
    ensure
      puts "\n\n\n"
      puts "Default data was successfully loaded. Enjoy !"
    end
  end
end