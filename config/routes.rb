ProjestimateMaquette::Application.routes.draw do

  get "wbs_activity/index"

  get "wbs_activity/edit"

  get "wbs_activity/new"

  match 'homes/update_install' => 'homes#update_install', :as => 'update_install'

  #GUIs controller
  #resources :gui
  #get "gui" => "gui#index", :as => "gui"

  resources :record_statuses

  resources :peicons
  match 'peicons/:id/choose_icon' => 'peicons#choose_icon', :as => "choose_icon"

  resources :auth_methods

  resources :admin_settings

  resources :master_settings

  resources :searches
  post "searches/results"
  get "user_search" => "searches#user_search", :as => "user_search"
  get "project_search" => "searches#project_search", :as => "project_search"

  get "translations/index"

  resources :project_security_levels

  resources :module_project_attributes

  resources :attribute_modules

  resources :module_projects

  resources :languages

  resources :project_securities
  get "select_users" => "project_securities#select_users", :as => "select_users"

  resources :attributes

  resources :project_categories

  resources :platform_categories

  resources :work_element_types

  resources :activity_categories

  resources :currencies

  resources :organization_labor_categories

  resources :organizations
  get "organizationals_params" => "organizations#organizationals_params", :as => "organizationals_params"

  resources :labor_categories

  resources :acquisition_categories

  resources :project_areas

  resources :event_types

  resources :events

  resources :permissions
  post "set_rights" => "permissions#set_rights", :as => "set_rights"
  post "set_rights_project_security" => "permissions#set_rights_project_security", :as => "set_rights_project_security"
  get "globals_permissions" => "permissions#globals_permissions", :as => "globals_permissions"

  resources :groups

  resources :pemodules
  get "processus" => "pemodules#processus"
  get "pemodules_down" => "pemodules#pemodules_down"
  get "pemodules_up" => "pemodules#pemodules_up"
  get "list_attributes" => "pemodules#list_attributes"
  get "update_selected_attributes" => "pemodules#update_selected_attributes"
  get "set_attributes_module" => "pemodules#set_attributes_module"
  get "estimations_params" => "pemodules#estimations_params", :as => "estimations_params"
  get "export_to_pdf" => "pemodules#export_to_pdf"

  resources :groups

  resources :components
  get "new" => "components#new"
  get "up" => "components#up"
  get "down" => "components#down"
  get "selected_component" => "components#selected_component"

  resources :wbs

  resources :projects
  get "add_module" => "projects#add_module"
  get "add_your_integrated_module" => "projects#add_your_integrated_module"
  get "select_categories" => "projects#select_categories", :as => "select_categories"
  get "run_estimation" => "projects#run_estimation", :as => "run_estimation"
  get "load_security_for_selected_user" => "projects#load_security_for_selected_user", :as => "load_security_for_selected_user"
  get "load_security_for_selected_group" => "projects#load_security_for_selected_group", :as => "load_security_for_selected_group"
  get "update_project_security_level" => "projects#update_project_security_level", :as => "update_project_security_level"
  get "update_project_security_level_group" => "projects#update_project_security_level_group", :as => "update_project_security_level_group"
  get "projects_global_params" => "projects#projects_global_params", :as => "projects_global_params"
  get "change_selected_project" => "projects#change_selected_project" , :as => "change_selected_project"
  get "commit" => "projects#commit" , :as => "commit"
  get "activate" => "projects#activate" , :as => "activate"
  get "find_use" => "projects#find_use" , :as => "find_use"
  get "check_in" => "projects#check_in" , :as => "check_in"
  get "check_out" => "projects#check_out" , :as => "check_out"
  get "project_record_number" => "projects#project_record_number", :as => "project_record_number"

  match 'projects/:project_id/duplicate' => 'projects#duplicate', :as => :duplicate

  resources :users
  get "show_login" => "users#show_login", :as => "show_login"
  get "dashboard" => "users#show", :as => "dashboard"
  get "sign_up" => "users#new", :as => "sign_up"
  get "admin" => "users#admin", :as => "admin"
  get "master" => "users#master", :as => "master"
  get "library" => "users#library", :as => "library"
  get "show_help" => "users#show_help", :as => "help_me"
  get "parameters" => "users#parameters", :as => "parameters"
  get "validate" => "users#validate", :as => "validate"
  get "projestimate_globals_parameters" => "users#projestimate_globals_parameters", :as => "projestimate_globals_parameters"
  post "create_inactive_user" => "users#create_inactive_user", :as => "create_inactive_user"
  get "find_use_user" => "users#find_use_user" , :as => "find_use_user"
  get "about" => "users#about" , :as => "about"
  match 'users/:id/activate' => 'users#activate', :as => 'activate'
  get "user_record_number" => "users#user_record_number", :as => "user_record_number"
  get "display_states" => "users#display_states", :as => "display_states"

  resources :password_resets

  resources :sessions
  get "log_in" => "sessions#new", :as => "log_in"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "ask_new_account"  => "sessions#ask_new_account", :as => "ask_new_account"
  get "help_login" => "sessions#help_login", :as => "help_login"

  #Master Data validation and restoration routes
  match ':controller/:id/validate_change' => ':controller#validate_change', :as => 'validate_change'
  match ':controller/:id/restore_change' => ':controller#restore_change', :as => 'restore_change'


  resources :translations
  get "load_translations" => "translations#load_translations", :as => "load_translations"

  post "save_cocomo_basic" => "cocomo_basics#save_cocomo_basic", :as => "EstimationControllers/save_cocomo_basic"

  root :to => "users#show"
end
