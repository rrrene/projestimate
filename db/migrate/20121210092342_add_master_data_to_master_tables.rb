# THIS MIGRATION ADD MASTER DATA
class AddMasterDataToMasterTables < ActiveRecord::Migration
  def change

    # ACQUISITION CATEGORY
    add_column :acquisition_categories, :uuid,              :string
    add_column :acquisition_categories, :record_status_id,  :integer
    add_column :acquisition_categories, :custom_value,      :string
    add_column :acquisition_categories, :owner_id,          :integer
    add_column :acquisition_categories, :change_comment,    :text
    add_column :acquisition_categories, :parent_id,         :integer
    add_column :acquisition_categories, :ref,               :string

    add_index :acquisition_categories, :record_status_id
    add_index :acquisition_categories, :owner_id
    add_index :acquisition_categories, :parent_id
    add_index :acquisition_categories, :uuid, :unique => true



    # ACTIVITY CATEGORY
    add_column :activity_categories, :uuid,             :string
    add_column :activity_categories, :record_status_id, :integer
    add_column :activity_categories, :custom_value,     :string
    add_column :activity_categories, :owner_id,         :integer
    add_column :activity_categories, :change_comment,   :text
    add_column :activity_categories, :parent_id,        :integer
    add_column :activity_categories, :ref,              :string

    add_index :activity_categories, :record_status_id
    add_index :activity_categories, :owner_id
    add_index :activity_categories, :parent_id
    add_index :activity_categories, :uuid, :unique => true


    # ATTRIBUTE
    add_column :attributes, :uuid,              :string
    add_column :attributes, :record_status_id,  :integer
    add_column :attributes, :custom_value,      :string
    add_column :attributes, :owner_id,          :integer
    add_column :attributes, :change_comment,    :text
    add_column :attributes, :parent_id,         :integer
    add_column :attributes, :ref,               :string

    add_index :attributes, :record_status_id
    add_index :attributes, :owner_id
    add_index :attributes, :parent_id
    add_index :attributes, :uuid, :unique => true


    # ATTRIBUTE MODULE
    add_column :attribute_modules, :uuid,              :string
    add_column :attribute_modules, :record_status_id,  :integer
    add_column :attribute_modules, :custom_value,      :string
    add_column :attribute_modules, :owner_id,          :integer
    add_column :attribute_modules, :change_comment,    :text
    add_column :attribute_modules, :parent_id,         :integer
    add_column :attribute_modules, :ref,               :string

    add_index :attribute_modules, :record_status_id
    add_index :attribute_modules, :owner_id
    add_index :attribute_modules, :parent_id
    add_index :attribute_modules, :uuid, :unique => true


    # CURRENCY
    add_column :currencies, :uuid,              :string
    add_column :currencies, :record_status_id,  :integer
    add_column :currencies, :custom_value,      :string
    add_column :currencies, :owner_id,          :integer
    add_column :currencies, :change_comment,    :text
    add_column :currencies, :parent_id,         :integer
    add_column :currencies, :ref,               :string

    add_index :currencies, :record_status_id
    add_index :currencies, :owner_id
    add_index :currencies, :parent_id
    add_index :currencies, :uuid, :unique => true


    # EVENT TYPE
    add_column :event_types, :uuid,             :string
    add_column :event_types, :record_status_id, :integer
    add_column :event_types, :custom_value,     :string
    add_column :event_types, :owner_id,         :integer
    add_column :event_types, :change_comment,   :text
    add_column :event_types, :parent_id,        :integer
    add_column :event_types, :ref,              :string

    add_index :event_types, :record_status_id
    add_index :event_types, :owner_id
    add_index :event_types, :parent_id
    add_index :event_types, :uuid, :unique => true


    # LABOR CATEGORY
    add_column :labor_categories, :uuid,             :string
    add_column :labor_categories, :record_status_id, :integer
    add_column :labor_categories, :custom_value,     :string
    add_column :labor_categories, :owner_id,         :integer
    add_column :labor_categories, :change_comment,   :text
    add_column :labor_categories, :parent_id,        :integer
    add_column :labor_categories, :ref,              :string

    add_index :labor_categories, :record_status_id
    add_index :labor_categories, :owner_id
    add_index :labor_categories, :parent_id
    add_index :labor_categories, :uuid, :unique => true


    # LANGUAGE
    add_column :languages, :uuid,              :string
    add_column :languages, :record_status_id,  :integer
    add_column :languages, :custom_value,      :string
    add_column :languages, :owner_id,          :integer
    add_column :languages, :change_comment,    :text
    add_column :languages, :parent_id,         :integer
    add_column :languages, :ref,               :string

    add_index :languages, :record_status_id
    add_index :languages, :owner_id
    add_index :languages, :parent_id
    add_index :languages, :uuid, :unique => true


    # MASTER SETTING
    add_column :master_settings, :uuid,              :string
    add_column :master_settings, :record_status_id,  :integer
    add_column :master_settings, :custom_value,      :string
    add_column :master_settings, :owner_id,          :integer
    add_column :master_settings, :change_comment,    :text
    add_column :master_settings, :parent_id,         :integer
    add_column :master_settings, :ref,               :string

    add_index :master_settings, :record_status_id
    add_index :master_settings, :owner_id
    add_index :master_settings, :parent_id
    add_index :master_settings, :uuid, :unique => true


    # PEICON
    add_column :peicons, :uuid,             :string
    add_column :peicons, :record_status_id, :integer
    add_column :peicons, :custom_value,     :string
    add_column :peicons, :owner_id,         :integer
    add_column :peicons, :change_comment,   :text
    add_column :peicons, :parent_id,        :integer
    add_column :peicons, :ref,              :string

    add_index :peicons, :record_status_id
    add_index :peicons, :owner_id
    add_index :peicons, :parent_id
    add_index :peicons, :uuid, :unique => true


    # PEMODULE
    add_column :pemodules, :uuid,             :string
    add_column :pemodules, :record_status_id, :integer
    add_column :pemodules, :custom_value,     :string
    add_column :pemodules, :owner_id,         :integer
    add_column :pemodules, :change_comment,   :text
    add_column :pemodules, :parent_id,        :integer
    add_column :pemodules, :ref,              :string

    add_index :pemodules, :record_status_id
    add_index :pemodules, :owner_id
    add_index :pemodules, :parent_id
    add_index :pemodules, :uuid, :unique => true



    # PLATFORM CATEGORY
    add_column :platform_categories, :uuid,             :string
    add_column :platform_categories, :record_status_id, :integer
    add_column :platform_categories, :custom_value,     :string
    add_column :platform_categories, :owner_id,         :integer
    add_column :platform_categories, :change_comment,   :text
    add_column :platform_categories, :parent_id,        :integer
    add_column :platform_categories, :ref,              :string

    add_index :platform_categories, :record_status_id
    add_index :platform_categories, :owner_id
    add_index :platform_categories, :parent_id
    add_index :platform_categories, :uuid, :unique => true


    # PROJECT AREA
    add_column :project_areas, :uuid,             :string
    add_column :project_areas, :record_status_id, :integer
    add_column :project_areas, :custom_value,     :string
    add_column :project_areas, :owner_id,         :integer
    add_column :project_areas, :change_comment,   :text
    add_column :project_areas, :parent_id,        :integer
    add_column :project_areas, :ref,              :string

    add_index :project_areas, :record_status_id
    add_index :project_areas, :owner_id
    add_index :project_areas, :parent_id
    add_index :project_areas, :uuid, :unique => true


    # PROJECT CATEGORY
    add_column :project_categories, :uuid,              :string
    add_column :project_categories, :record_status_id,  :integer
    add_column :project_categories, :custom_value,      :string
    add_column :project_categories, :owner_id,          :integer
    add_column :project_categories, :change_comment,    :text
    add_column :project_categories, :parent_id,         :integer
    add_column :project_categories, :ref,               :string

    add_index :project_categories, :record_status_id
    add_index :project_categories, :owner_id
    add_index :project_categories, :parent_id
    add_index :project_categories, :uuid, :unique => true


    # PROJECT SECURITY LEVEL
    add_column :project_security_levels, :uuid,                :string
    add_column :project_security_levels, :record_status_id,    :integer
    add_column :project_security_levels, :custom_value,        :string
    add_column :project_security_levels, :owner_id,            :integer
    add_column :project_security_levels, :change_comment,      :text
    add_column :project_security_levels, :parent_id,           :integer
    add_column :project_security_levels, :ref,                 :string

    add_index :project_security_levels, :record_status_id
    add_index :project_security_levels, :owner_id
    add_index :project_security_levels, :parent_id
    add_index :project_security_levels, :uuid, :unique => true


    # WORK ELEMENT TYPE
    add_column :work_element_types, :uuid,              :string
    add_column :work_element_types, :record_status_id,  :integer
    add_column :work_element_types, :custom_value,      :string
    add_column :work_element_types, :owner_id,          :integer
    add_column :work_element_types, :change_comment,    :text
    add_column :work_element_types, :parent_id,         :integer
    add_column :work_element_types, :ref,               :string

    add_index :work_element_types, :record_status_id
    add_index :work_element_types, :owner_id
    add_index :work_element_types, :parent_id
    add_index :work_element_types, :uuid, :unique => true


    # RECORD STATUS
    create_table :record_statuses, :force => true  do |t|
      t.string :name
      t.string :description
      t.string :uuid
      t.integer :record_status_id
      t.string  :custom_value
      t.integer :owner_id
      t.text    :change_comment
      t.integer :parent_id
      t.string  :ref

      t.timestamps
    end
    add_index :record_statuses, :record_status_id
    add_index :record_statuses, :owner_id
    add_index :record_statuses, :parent_id
    add_index :record_statuses, :uuid, :unique => true



    ## SPECIAL TABLES :

    # ADMIN SETTING
    add_column :admin_settings, :uuid,             :string
    add_column :admin_settings, :record_status_id, :integer
    add_column :admin_settings, :custom_value,     :string
    add_column :admin_settings, :owner_id,         :integer
    add_column :admin_settings, :change_comment,   :text
    add_column :admin_settings, :parent_id,        :integer
    add_column :admin_settings, :ref,              :string

    add_index :admin_settings, :record_status_id
    add_index :admin_settings, :owner_id
    add_index :admin_settings, :parent_id
    add_index :admin_settings, :uuid, :unique => true


    # AUTH METHOD
    add_column :auth_methods, :uuid,             :string
    add_column :auth_methods, :record_status_id, :integer
    add_column :auth_methods, :custom_value,     :string
    add_column :auth_methods, :owner_id,         :integer
    add_column :auth_methods, :change_comment,   :text
    add_column :auth_methods, :parent_id,        :integer
    add_column :auth_methods, :ref,              :string

    add_index :auth_methods, :record_status_id
    add_index :auth_methods, :owner_id
    add_index :auth_methods, :parent_id
    add_index :auth_methods, :uuid, :unique => true


    # GROUP
    add_column :groups, :uuid,             :string
    add_column :groups, :record_status_id, :integer
    add_column :groups, :custom_value,     :string
    add_column :groups, :owner_id,         :integer
    add_column :groups, :change_comment,   :text
    add_column :groups, :parent_id,        :integer
    add_column :groups, :ref,              :string

    add_index :groups, :record_status_id
    add_index :groups, :owner_id
    add_index :groups, :parent_id
    add_index :groups, :uuid, :unique => true


    # PERMISSION
    add_column :permissions, :uuid,             :string
    add_column :permissions, :record_status_id, :integer
    add_column :permissions, :custom_value,     :string
    add_column :permissions, :owner_id,         :integer
    add_column :permissions, :change_comment,   :text
    add_column :permissions, :parent_id,        :integer
    add_column :permissions, :ref,              :string

    add_index :permissions, :record_status_id
    add_index :permissions, :owner_id
    add_index :permissions, :parent_id
    add_index :permissions, :uuid, :unique => true

  end
end
