#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


    ActivityCategory.delete_all
    LaborCategory.delete_all
    AcquisitionCategory.delete_all
    User.delete_all
    Language.delete_all
    Project.delete_all
    Wbs.delete_all
    Group.delete_all
    WorkElementType.delete_all
    Component.delete_all


    begin

      group_array = Array.new
      group_array = [
                      ["SuperAdmin"],
                      ["Admin"],
                      ["Everyone"]
                    ]

      group_array.each do |i|
        Group.create(:name => i[0])
      end

      [["FullControl", 4], ["Define", 3], ["Modify", 2], ["Comment", 1], ["ReadOnly", 0]].each do |psl|
        ProjectSecurityLevel.create(:name => psl[0], :level => psl[1])
      end
      full_control = ProjectSecurityLevel.find_by_name("FullControl")

      [["User", "edit_own_profile", "Editer son profil", false, [2, 1, 3], []], ["Component", "validate_user_account", "Valider les comptes utilisateur\r\n", false, [1, 2], []], ["User", "edit_user_account_no_admin", "Editer les comptes utilisateurs (non admin)", false, [1, 2], []], ["User", "edit_account_super_admin", "Editer les comptes SuperAdmin", false, [1], []], ["User", "edit_account_admin", "Editer les comptes Admin", false, [1, 2], []], ["Group", "edit_groups", "Editer les groupes", false, [1], []], ["Permission", "manage_permissions", "Gérer toutes les permissions", true, [1, 2], []], ["Permission", "manage_specific_permissions", "Gérer les permissions spécifiques à un projet", false, [1], []], ["ProjectArea", "manage_project_area", "Gérer les Domaines de projet", false, [1, 2], []], ["Currency", "manage_currency", "Gérer les Monnaies", false, [1], []], ["Organization", "manage_organizations", "Gérer les Organisations", false, [1], []], ["LaborCategory", "manage_labor_categories", "Gérer les catégories de Travailleurs", false, [1], []], ["EventType", "manage_event_types", "Gérer les type d'evenement", true, [1], []], ["ProjectCategory", "manage_project_categories", "Gérer les Catégories de projet", false, [1], []], ["PlatformCategory", "manage_platform_categories", "Gérer les catégories de Platformes", false, [1], []], ["AcquisitionCategory", "manage_acquisition_categories", "Gérer les catégories d'acquisition", false, [1], []], ["WorkElementType", "manage_wet", "Gérer les Work Element Type", false, [1], []], ["Attribute", "manage_attributes", "Gérer les attributs", false, [1], []], ["Pemodule", "manage_modules", "Gérer les modules", false, [1], []], ["ActivityCategory", "manage_activity_categories", "Gérer les Catégories d'activités", false, [1], []], ["Help", "view_help", "Acceder à l'aide", false, [1, 2, 3], []], ["Help", "manage_help_messages", "Gérer les messages d'aide", false, [1], []], ["Language", "edit_languages", "Manage languages of the application", false, [1, 2, 3], []], ["User", "access_to_admin", "Access to administration page", false, [1], []], ["Project", "create_new_project", "Créer un nouveau projet", false, [1, 2], []], ["Project", "delete_a_project", "Supprimer un projet", true, [], [1]], ["Project", "edit_a_project", "Editer un projet", true, [], [1, 2, 3]], ["Project", "modify_a_project", "Modifier un projet", true, [], [1, 2, 3, 4]], ["Project", "access_to_a_project", "Accéder à un projet", true, [], [1, 2, 3, 4, 5]], ["Project", "list_project", "Lister un projet (index des projets)", true, [], [2, 3, 4, 5, 1]], ["Component", "add_a_component", "Ajouter un composant", true, [], [2, 3, 1]], ["Component", "delete_a_component", "Supprimer un composant", true, [], [2, 3, 1]], ["Component", "move_a_component", "Déplacer un composant", true, [], [2, 3, 4, 1]], ["Component", "edit_a_component", "Editer un composant", true, [], [2, 3, 4, 1]], ["Component", "access_to_a_component", "Accéder à un composant", true, [], [1, 2, 3, 4, 5]], ["ModuleProject", "add_a_module_to_a_process", "Ajouter un module au processus d’estimation du projet", true, [], [1, 2, 3]], ["ModuleProject", "delete_a_module_project", "Supprimer un module project", true, [], [1, 2, 3]], ["ModuleProject", "move_a_module_project", "Déplacer un module project", true, [], [1, 2, 3, 4]], ["ModuleProject", "edit_a_module_project", "Editer un module", true, [], [1, 2, 3, 4]], ["ModuleProject", "run_estimation_process", "Exécuter un processus d'estimation", true, [], [1, 2, 3, 4]], ["ModuleProject", "access_to_a_module", "Accéder aux modules", true, [], [1, 2, 3, 4, 5]], ["ModuleProjectAttribute", "add_an_attribute", "Ajouter un attribut", true, [], [1, 2, 3]], ["ModuleProjectAttribute", "delete_an_attribute", "Supprimer un attribut", true, [], [1, 2, 3]], ["ModuleProjectAttribute", "edit_an_attribute", "Editer un attribut", true, [], [1, 2, 3]], ["ModuleProjectAttribute", "access_to_attributes", "Accéder aux attributs projets", true, [], [1, 2, 3, 4, 5]], ["User", "edit_own_profile_security", "Editer tous les droits", false, [1, 2], []], ["Help", "edit_faq", "Editer la Faq", false, [1], []]].each do |perm|
         Permission.create(:name => perm[1], :object_associated => perm[0], :description => perm[2], :is_permission_project => perm[3], :group_ids => perm[4], :project_security_level_ids => perm[5])
      end

      Language.create(:name => "Français", :locale => "fr")

      wet = WorkElementType.create(:name => "Folder", :alias => "folder")
      WorkElementType.create(:name => "Link", :alias => "link")
      WorkElementType.create(:name => "Development", :alias => "development")
      WorkElementType.create(:name => "Cots", :alias => "cots")
      WorkElementType.create(:name => "Undefined", :alias => "undefined")


      Project.create(:title => "Your first project", :description => "Description of your first project", :alias => "project", :state => "open", :start_date => Time.now, :is_model => true)
      project = Project.first

      Wbs.create(:project_id => project.id)
      wbs = Wbs.first

      component = Component.create(:is_root => true, :wbs_id => wbs.id, :work_element_type_id => wet.id, :position => 0, :name => "Root folder")
      component = Component.first

      User.create(:first_name => "admin", :surename => "admin", :user_name => "admin", :initials => "ad", :email => "nicolas.renard@spirula.fr", :type_auth => "app", :user_status => "active")
      user = User.first
      user.password = "projestimate"
      user.language = Language.first
      user.project_ids = [project.id]
      user.save

     user.group_ids = [Group.first.id]
     user.save

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

    ProjectSecurity.create(:project_id => project.id, :user_id => user.id, :project_security_level_id => full_control.id)

    [["KSLOC", "ksloc", "Kilo Size Line Of Code.", 0, "sum"], ["Cost", "cost", "Cost of a product, a service or a processus.", 0, "sum"], ["Delay", "delay", "Time allowed for the completion of something.", 0, "average"], ["Staffing", "staffing", "Staff required to accomplish a task", 0, "sum"], ["Staffing complexity", "staffing_complexity", "A rating of the project's inherent difficulty in terms of the rate at which staff are added to a project.", 0, "average"], ["Effective technology", "effective_technology", "A composite metric that captures factors relating to the efficiency or productivity with which development can be carried out.", 0, "average"], ["End date", "end_date", "End date for a task, a component. Dependent of delay.", 2, "maxi"], ["Effort", "effort", "Effort in Man-Months", 0, "average"], ["Duration", "duration", "Duration of a task", 0, "average"]].each do |attr|
      Attribute.create(:name => attr[0], :alias => attr[1], :description => attr[2], :attr_type => attr[3], :aggregation => attr[4])
    end

      Organization.create(:name => "default", :description => "Default organizations")

        puts "Default data data loaded ! Enjoy."
    rescue
      puts "Default data was not loaded."
    end