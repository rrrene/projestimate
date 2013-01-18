# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130118103846) do

  create_table "acquisition_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "acquisition_categories", ["owner_id"], :name => "index_acquisition_categories_on_owner_id"
  add_index "acquisition_categories", ["parent_id"], :name => "index_acquisition_categories_on_parent_id"
  add_index "acquisition_categories", ["record_status_id"], :name => "index_acquisition_categories_on_record_status_id"
  add_index "acquisition_categories", ["uuid"], :name => "index_acquisition_categories_on_uuid", :unique => true

  create_table "acquisition_categories_project_areas", :id => false, :force => true do |t|
    t.integer  "acquisition_category_id"
    t.integer  "project_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "alias"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "activity_categories", ["owner_id"], :name => "index_activity_categories_on_owner_id"
  add_index "activity_categories", ["parent_id"], :name => "index_activity_categories_on_parent_id"
  add_index "activity_categories", ["record_status_id"], :name => "index_activity_categories_on_record_status_id"
  add_index "activity_categories", ["uuid"], :name => "index_activity_categories_on_uuid", :unique => true

  create_table "activity_categories_project_areas", :id => false, :force => true do |t|
    t.integer  "activity_category_id"
    t.integer  "project_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_settings", :force => true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "admin_settings", ["owner_id"], :name => "index_admin_settings_on_owner_id"
  add_index "admin_settings", ["parent_id"], :name => "index_admin_settings_on_parent_id"
  add_index "admin_settings", ["record_status_id"], :name => "index_admin_settings_on_record_status_id"
  add_index "admin_settings", ["uuid"], :name => "index_admin_settings_on_uuid", :unique => true

  create_table "attribute_modules", :force => true do |t|
    t.integer  "attribute_id"
    t.integer  "pemodule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_mandatory"
    t.string   "in_out"
    t.text     "description"
    t.string   "string_data_low"
    t.string   "string_data_most_likely"
    t.string   "string_data_high"
    t.integer  "numeric_data_low"
    t.integer  "numeric_data_most_likely"
    t.integer  "numeric_data_high"
    t.date     "date_data_low"
    t.date     "date_data_most_likely"
    t.date     "date_data_high"
    t.integer  "dimensions"
    t.string   "custom_attribute"
    t.string   "project_value"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "attribute_modules", ["owner_id"], :name => "index_attribute_modules_on_owner_id"
  add_index "attribute_modules", ["parent_id"], :name => "index_attribute_modules_on_parent_id"
  add_index "attribute_modules", ["record_status_id"], :name => "index_attribute_modules_on_record_status_id"
  add_index "attribute_modules", ["uuid"], :name => "index_attribute_modules_on_uuid", :unique => true

  create_table "attributes", :force => true do |t|
    t.string   "name"
    t.string   "alias"
    t.text     "description"
    t.string   "attr_type"
    t.text     "options"
    t.text     "aggregation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "attributes", ["owner_id"], :name => "index_attributes_on_owner_id"
  add_index "attributes", ["parent_id"], :name => "index_attributes_on_parent_id"
  add_index "attributes", ["record_status_id"], :name => "index_attributes_on_record_status_id"
  add_index "attributes", ["uuid"], :name => "index_attributes_on_uuid", :unique => true

  create_table "auth_methods", :force => true do |t|
    t.string   "name"
    t.string   "server_name"
    t.integer  "port"
    t.string   "base_dn"
    t.string   "user_name_attribute"
    t.boolean  "certificate"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "auth_methods", ["owner_id"], :name => "index_auth_methods_on_owner_id"
  add_index "auth_methods", ["parent_id"], :name => "index_auth_methods_on_parent_id"
  add_index "auth_methods", ["record_status_id"], :name => "index_auth_methods_on_record_status_id"
  add_index "auth_methods", ["uuid"], :name => "index_auth_methods_on_uuid", :unique => true

  create_table "components", :force => true do |t|
    t.integer  "pe_wbs_project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.boolean  "is_root"
    t.integer  "work_element_type_id"
    t.string   "name"
    t.integer  "project_link"
    t.integer  "position"
    t.integer  "copy_id"
  end

  add_index "components", ["ancestry"], :name => "index_components_on_ancestry"

  create_table "currencies", :force => true do |t|
    t.string   "name"
    t.string   "alias"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "currencies", ["owner_id"], :name => "index_currencies_on_owner_id"
  add_index "currencies", ["parent_id"], :name => "index_currencies_on_parent_id"
  add_index "currencies", ["record_status_id"], :name => "index_currencies_on_record_status_id"
  add_index "currencies", ["uuid"], :name => "index_currencies_on_uuid", :unique => true

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "icon_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "event_types", ["owner_id"], :name => "index_event_types_on_owner_id"
  add_index "event_types", ["parent_id"], :name => "index_event_types_on_parent_id"
  add_index "event_types", ["record_status_id"], :name => "index_event_types_on_record_status_id"
  add_index "event_types", ["uuid"], :name => "index_event_types_on_uuid", :unique => true

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "event_type_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "code_group"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "for_global_permission"
    t.boolean  "for_project_security"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "groups", ["owner_id"], :name => "index_groups_on_owner_id"
  add_index "groups", ["parent_id"], :name => "index_groups_on_parent_id"
  add_index "groups", ["record_status_id"], :name => "index_groups_on_record_status_id"
  add_index "groups", ["uuid"], :name => "index_groups_on_uuid", :unique => true

  create_table "groups_permissions", :id => false, :force => true do |t|
    t.integer  "group_id"
    t.integer  "permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_projects", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "project_id"
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "help_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helps", :force => true do |t|
    t.text     "content"
    t.integer  "help_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "help_code"
  end

  create_table "homes", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "labor_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "labor_categories", ["owner_id"], :name => "index_labor_categories_on_owner_id"
  add_index "labor_categories", ["parent_id"], :name => "index_labor_categories_on_parent_id"
  add_index "labor_categories", ["record_status_id"], :name => "index_labor_categories_on_record_status_id"
  add_index "labor_categories", ["uuid"], :name => "index_labor_categories_on_uuid", :unique => true

  create_table "labor_categories_project_areas", :id => false, :force => true do |t|
    t.integer  "labor_category_id"
    t.integer  "project_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "languages", ["owner_id"], :name => "index_languages_on_owner_id"
  add_index "languages", ["parent_id"], :name => "index_languages_on_parent_id"
  add_index "languages", ["record_status_id"], :name => "index_languages_on_record_status_id"
  add_index "languages", ["uuid"], :name => "index_languages_on_uuid", :unique => true

  create_table "links_module_project_attributes", :id => false, :force => true do |t|
    t.integer "link_id"
    t.integer "module_project_attribute_id"
  end

  create_table "master_settings", :force => true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "master_settings", ["owner_id"], :name => "index_master_settings_on_owner_id"
  add_index "master_settings", ["parent_id"], :name => "index_master_settings_on_parent_id"
  add_index "master_settings", ["record_status_id"], :name => "index_master_settings_on_record_status_id"
  add_index "master_settings", ["uuid"], :name => "index_master_settings_on_uuid", :unique => true

  create_table "module_project_attributes", :force => true do |t|
    t.integer  "attribute_id"
    t.string   "string_data_low"
    t.string   "string_data_most_likely"
    t.string   "string_data_high"
    t.float    "numeric_data_low"
    t.float    "numeric_data_most_likely"
    t.float    "numeric_data_high"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "links"
    t.boolean  "is_mandatory"
    t.string   "in_out"
    t.text     "description"
    t.integer  "module_project_id"
    t.date     "date_data_low"
    t.date     "date_data_most_likely"
    t.date     "date_data_high"
    t.boolean  "undefined_attribute"
    t.integer  "component_id"
    t.integer  "dimensions"
    t.string   "custom_attribute"
    t.string   "project_value"
    t.string   "ancestry"
  end

  add_index "module_project_attributes", ["ancestry"], :name => "index_module_project_attributes_on_ancestry"
  add_index "module_project_attributes", ["links"], :name => "index_attribute_projects_on_links"

  create_table "module_projects", :force => true do |t|
    t.integer  "pemodule_id"
    t.integer  "project_id"
    t.integer  "position_y"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "nb_input_attr"
    t.integer  "nb_output_attr"
    t.integer  "position_x"
  end

  create_table "organization_labor_categories", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "labor_category_id"
    t.string   "level"
    t.string   "name"
    t.text     "description"
    t.float    "cost_per_hour"
    t.integer  "base_year"
    t.integer  "currency_id"
    t.float    "hour_per_day"
    t.integer  "days_per_year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "organization_id"
  end

  create_table "pe_wbs_projects", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "peicons", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "peicons", ["owner_id"], :name => "index_peicons_on_owner_id"
  add_index "peicons", ["parent_id"], :name => "index_peicons_on_parent_id"
  add_index "peicons", ["record_status_id"], :name => "index_peicons_on_record_status_id"
  add_index "peicons", ["uuid"], :name => "index_peicons_on_uuid", :unique => true

  create_table "pemodules", :force => true do |t|
    t.string   "title"
    t.string   "alias"
    t.text     "description"
    t.integer  "type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "compliant_component_type"
    t.boolean  "is_typed"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "pemodules", ["owner_id"], :name => "index_pemodules_on_owner_id"
  add_index "pemodules", ["parent_id"], :name => "index_pemodules_on_parent_id"
  add_index "pemodules", ["record_status_id"], :name => "index_pemodules_on_record_status_id"
  add_index "pemodules", ["uuid"], :name => "index_pemodules_on_uuid", :unique => true

  create_table "permissions", :force => true do |t|
    t.string   "object_associated"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_permission_project"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "permissions", ["owner_id"], :name => "index_permissions_on_owner_id"
  add_index "permissions", ["parent_id"], :name => "index_permissions_on_parent_id"
  add_index "permissions", ["record_status_id"], :name => "index_permissions_on_record_status_id"
  add_index "permissions", ["uuid"], :name => "index_permissions_on_uuid", :unique => true

  create_table "permissions_project_security_levels", :id => false, :force => true do |t|
    t.integer  "permission_id"
    t.integer  "project_security_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions_users", :id => false, :force => true do |t|
    t.integer  "permission_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "platform_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "platform_categories", ["owner_id"], :name => "index_platform_categories_on_owner_id"
  add_index "platform_categories", ["parent_id"], :name => "index_platform_categories_on_parent_id"
  add_index "platform_categories", ["record_status_id"], :name => "index_platform_categories_on_record_status_id"
  add_index "platform_categories", ["uuid"], :name => "index_platform_categories_on_uuid", :unique => true

  create_table "platform_categories_project_areas", :id => false, :force => true do |t|
    t.integer  "platform_category_id"
    t.integer  "project_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_areas", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "project_areas", ["owner_id"], :name => "index_project_areas_on_owner_id"
  add_index "project_areas", ["parent_id"], :name => "index_project_areas_on_parent_id"
  add_index "project_areas", ["record_status_id"], :name => "index_project_areas_on_record_status_id"
  add_index "project_areas", ["uuid"], :name => "index_project_areas_on_uuid", :unique => true

  create_table "project_areas_project_categories", :id => false, :force => true do |t|
    t.integer  "project_category_id"
    t.integer  "project_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_areas_work_element_types", :id => false, :force => true do |t|
    t.integer  "project_area_id"
    t.integer  "work_element_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "project_categories", ["owner_id"], :name => "index_project_categories_on_owner_id"
  add_index "project_categories", ["parent_id"], :name => "index_project_categories_on_parent_id"
  add_index "project_categories", ["record_status_id"], :name => "index_project_categories_on_record_status_id"
  add_index "project_categories", ["uuid"], :name => "index_project_categories_on_uuid", :unique => true

  create_table "project_ressources", :force => true do |t|
    t.string "name"
  end

  create_table "project_securities", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "project_security_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  create_table "project_security_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "project_security_levels", ["owner_id"], :name => "index_project_security_levels_on_owner_id"
  add_index "project_security_levels", ["parent_id"], :name => "index_project_security_levels_on_parent_id"
  add_index "project_security_levels", ["record_status_id"], :name => "index_project_security_levels_on_record_status_id"
  add_index "project_security_levels", ["uuid"], :name => "index_project_security_levels_on_uuid", :unique => true

  create_table "project_staffs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "alias"
    t.string   "state"
    t.date     "start_date"
    t.integer  "organization_id"
    t.integer  "project_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_category_id"
    t.integer  "platform_category_id"
    t.integer  "acquisition_category_id"
    t.boolean  "is_model"
    t.string   "version"
    t.integer  "version_ancestry"
    t.integer  "master_anscestry"
    t.integer  "owner"
    t.text     "purpose"
    t.text     "level_of_detail"
    t.text     "scope"
    t.integer  "copy_number"
  end

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "record_statuses", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.integer  "status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "record_statuses", ["owner_id"], :name => "index_record_statuses_on_owner_id"
  add_index "record_statuses", ["parent_id"], :name => "index_record_statuses_on_parent_id"
  add_index "record_statuses", ["record_status_id"], :name => "index_record_statuses_on_record_status_id"
  add_index "record_statuses", ["uuid"], :name => "index_record_statuses_on_uuid", :unique => true

  create_table "results", :force => true do |t|
    t.integer "functionality_id"
    t.integer "step"
    t.text    "content"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "initials"
    t.date     "last_login"
    t.date     "previous_login"
    t.string   "time_zone"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "language_id"
    t.integer  "auth_type"
    t.string   "user_status"
    t.text     "ten_latest_projects"
    t.integer  "organization_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login_name"], :name => "index_users_on_login_name", :unique => true

  create_table "wbs_activities", :force => true do |t|
    t.string   "uuid"
    t.string   "name"
    t.string   "state"
    t.text     "description"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "wbs_activity_elements", :force => true do |t|
    t.string   "uuid"
    t.integer  "wbs_activity_id"
    t.string   "name"
    t.text     "description"
    t.string   "ancestry"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "wbs_activity_elements", ["ancestry"], :name => "index_wbs_activity_elements_on_ancestry"
  add_index "wbs_activity_elements", ["wbs_activity_id"], :name => "index_wbs_activity_elements_on_wbs_activity_id"

  create_table "work_element_types", :force => true do |t|
    t.string   "name"
    t.string   "alias"
    t.text     "description"
    t.integer  "project_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "peicon_id"
    t.string   "uuid"
    t.integer  "record_status_id"
    t.string   "custom_value"
    t.integer  "owner_id"
    t.text     "change_comment"
    t.integer  "parent_id"
    t.string   "ref"
  end

  add_index "work_element_types", ["owner_id"], :name => "index_work_element_types_on_owner_id"
  add_index "work_element_types", ["parent_id"], :name => "index_work_element_types_on_parent_id"
  add_index "work_element_types", ["record_status_id"], :name => "index_work_element_types_on_record_status_id"
  add_index "work_element_types", ["uuid"], :name => "index_work_element_types_on_uuid", :unique => true

end
