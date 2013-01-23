class RenameParentIdInMasterTables < ActiveRecord::Migration

  def change
    # ACQUISITION CATEGORY
    rename_column :acquisition_categories, :parent_id, :reference_id
    rename_column :acquisition_categories, :ref,       :reference_uuid
    rename_index  :acquisition_categories, :parent_id, :reference_id
    remove_index  :acquisition_categories, :owner_id

    # ACTIVITY CATEGORY
    rename_column :activity_categories, :parent_id, :reference_id
    rename_column :activity_categories, :ref,       :reference_uuid
    rename_index  :activity_categories, :parent_id, :reference_id
    remove_index  :activity_categories, :owner_id

    # ATTRIBUTE
    rename_column :attributes, :parent_id, :reference_id
    rename_column :attributes, :ref,       :reference_uuid
    rename_index  :attributes, :parent_id, :reference_id
    remove_index  :attributes, :owner_id

    # ATTRIBUTE MODULE
    rename_column :attribute_modules, :parent_id, :reference_id
    rename_column :attribute_modules, :ref,       :reference_uuid
    rename_index  :attribute_modules, :parent_id, :reference_id
    remove_index  :attribute_modules, :owner_id

    # CURRENCY
    rename_column :currencies, :parent_id, :reference_id
    rename_column :currencies, :ref,       :reference_uuid
    rename_index  :currencies, :parent_id, :reference_id
    remove_index  :currencies, :owner_id

    # EVENT TYPE
    rename_column :event_types, :parent_id, :reference_id
    rename_column :event_types, :ref,       :reference_uuid
    rename_index  :event_types, :parent_id, :reference_id
    remove_index  :event_types, :owner_id

    # LABOR CATEGORY
    rename_column :labor_categories, :parent_id, :reference_id
    rename_column :labor_categories, :ref,       :reference_uuid
    rename_index  :labor_categories, :parent_id, :reference_id
    remove_index  :labor_categories, :owner_id

    # LANGUAGE
    rename_column :languages, :parent_id, :reference_id
    rename_column :languages, :ref,       :reference_uuid
    rename_index  :languages, :parent_id, :reference_id
    remove_index  :languages, :owner_id

    # MASTER SETTING
    rename_column :master_settings, :parent_id, :reference_id
    rename_column :master_settings, :ref,       :reference_uuid
    rename_index  :master_settings, :parent_id, :reference_id
    remove_index  :master_settings, :owner_id

    # PEICON
    rename_column :peicons, :parent_id, :reference_id
    rename_column :peicons, :ref,       :reference_uuid
    rename_index  :peicons, :parent_id, :reference_id
    remove_index  :peicons, :owner_id

    # PEMODULE
    rename_column :pemodules, :parent_id, :reference_id
    rename_column :pemodules, :ref,       :reference_uuid
    rename_index  :pemodules, :parent_id, :reference_id
    remove_index  :pemodules, :owner_id

    # PERMISSION
    rename_column :permissions, :parent_id, :reference_id
    rename_column :permissions, :ref,       :reference_uuid
    rename_index  :permissions, :parent_id, :reference_id
    remove_index  :permissions, :owner_id

    # PLATFORM CATEGORY
    rename_column :platform_categories, :parent_id, :reference_id
    rename_column :platform_categories, :ref,       :reference_uuid
    rename_index  :platform_categories, :parent_id, :reference_id
    remove_index  :platform_categories, :owner_id


    # PROJECT AREA
    rename_column :project_areas, :parent_id, :reference_id
    rename_column :project_areas, :ref,       :reference_uuid
    rename_index  :project_areas, :parent_id, :reference_id
    remove_index  :project_areas, :owner_id

    # PROJECT CATEGORY
    rename_column :project_categories, :parent_id, :reference_id
    rename_column :project_categories, :ref,       :reference_uuid
    rename_index  :project_categories, :parent_id, :reference_id
    remove_index  :project_categories, :owner_id

    # PROJECT SECURITY LEVEL
    rename_column :project_security_levels, :parent_id, :reference_id
    rename_column :project_security_levels, :ref,       :reference_uuid
    rename_index  :project_security_levels, :parent_id, :reference_id
    remove_index  :project_security_levels, :owner_id

    # WORK ELEMENT TYPE
    rename_column :work_element_types, :parent_id, :reference_id
    rename_column :work_element_types, :ref,       :reference_uuid
    rename_index  :work_element_types, :parent_id, :reference_id
    remove_index  :work_element_types, :owner_id

    # RECORD STATUS
    rename_column :record_statuses, :parent_id, :reference_id
    rename_column :record_statuses, :ref,       :reference_uuid
    rename_index  :record_statuses, :parent_id, :reference_id
    remove_index  :record_statuses, :owner_id


    ## SPECIAL TABLES :

    # ADMIN SETTING
    rename_column :admin_settings, :parent_id, :reference_id
    rename_column :admin_settings, :ref,       :reference_uuid
    rename_index  :admin_settings, :parent_id, :reference_id
    remove_index  :admin_settings, :owner_id

    # AUTH METHOD
    rename_column :auth_methods, :parent_id, :reference_id
    rename_column :auth_methods, :ref,       :reference_uuid
    rename_index  :auth_methods, :parent_id, :reference_id
    remove_index  :auth_methods, :owner_id

    # GROUP
    rename_column :groups, :parent_id, :reference_id
    rename_column :groups, :ref,       :reference_uuid
    rename_index  :groups, :parent_id, :reference_id
    remove_index  :groups, :owner_id

  end

end
