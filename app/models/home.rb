class Home < ActiveRecord::Base
  include ExternalMasterDatabase

  EXTERNAL_BASES = [ExternalWbsActivityElement, ExternalWbsActivity, ExternalLanguage, ExternalAttribute, ExternalMasterSetting, ExternalProjectArea, ExternalProjectCategory, ExternalPlatformCategory, ExternalAcquisitionCategory, ExternalPeicon,
                    ExternalWorkElementType, ExternalCurrency, ExternalAdminSetting, ExternalAuthMethod, ExternalGroup, ExternalLaborCategory, ExternalActivityCategory, ExternalProjectSecurityLevel,
                    ExternalPermission]

  def self.update_master_data!
    puts "Updating from Master Data..."
    #begin

      puts "   - Reference Value"
      self.update_records(ExternalMasterDatabase::ExternalReferenceValue, ReferenceValue, ["value", "uuid"])

      puts "   - WBS Activity"
      self.update_records(ExternalMasterDatabase::ExternalWbsActivity, WbsActivity, ["name", "description", "uuid"])

      puts "   - WBS Activity Elements"
      self.update_records(ExternalMasterDatabase::ExternalWbsActivityElement, WbsActivityElement, ["name", "description", "dotted_id", "uuid", "is_root"])

      puts "   - Wbs Activity Ratio"
      self.update_records(ExternalMasterDatabase::ExternalWbsActivityRatio, WbsActivityRatio, ["name", "description", "uuid"])

      puts "   - Wbs Activity Ratio Elements"
      self.update_records(ExternalMasterDatabase::ExternalWbsActivityRatioElement, WbsActivityRatioElement, ["ratio_value", "simple_reference", "multiple_references", "uuid"])

      puts "   - Master Settings"
      self.update_records(ExternalMasterDatabase::ExternalMasterSetting, MasterSetting, ["key", "value", "uuid"])

      puts "   - Project areas"
      self.update_records(ExternalMasterDatabase::ExternalProjectArea, ProjectArea, ["name", "description", "uuid"])

      puts "   - Project categories"
      self.update_records(ExternalMasterDatabase::ExternalProjectCategory, ProjectCategory, ["name", "description", "uuid"])

      puts "   - Platform categories"
      self.update_records(ExternalMasterDatabase::ExternalPlatformCategory, PlatformCategory, ["name", "description", "uuid"])

      puts "   - Acquisition categories"
      self.update_records(ExternalMasterDatabase::ExternalAcquisitionCategory, AcquisitionCategory, ["name", "description", "uuid"])

      puts "   - Attribute..."
      self.update_records(ExternalMasterDatabase::ExternalAttribute, Object::Attribute, ["name", "alias", "description", "attr_type", "aggregation", "uuid"])

      puts "   - Projestimate Icons"
      self.update_records(ExternalMasterDatabase::ExternalPeicon, Peicon, ["name", "icon_file_name", "icon_content_type", "icon_updated_at", "icon_file_size", "uuid"])

      puts "   - WorkElementType"
      self.update_records(ExternalMasterDatabase::ExternalWorkElementType, WorkElementType, ["name", "alias", "peicon_id", "uuid"])

      puts "   - Currencies"
      self.update_records(ExternalMasterDatabase::ExternalCurrency, Currency, ["name", "description", "uuid"])

      puts "   - Language..."
      self.update_records(ExternalMasterDatabase::ExternalLanguage, Language, ["name", "locale", "uuid"])

      puts "   - Admin Settings"
      self.update_records(ExternalMasterDatabase::ExternalAdminSetting, AdminSetting, ["key", "value", "uuid"])

      puts "   - Auth Method"
      self.update_records(ExternalMasterDatabase::ExternalAuthMethod, AuthMethod, ["name", "server_name", "port", "base_dn", "certificate", "uuid"])

      puts "   - Default groups"
      self.update_records(ExternalMasterDatabase::ExternalGroup, Group, ["name", "description", "uuid"])

      puts "   - Labor categories"
      self.update_records(ExternalMasterDatabase::ExternalLaborCategory, LaborCategory, ["name", "description", "uuid"])

      puts "   - Activity categories"
      self.update_records(ExternalMasterDatabase::ExternalActivityCategory, ActivityCategory, ["name", "alias", "description", "uuid"])

      puts "Create project security level..."
      self.update_records(ExternalMasterDatabase::ExternalProjectSecurityLevel, ProjectSecurityLevel, ["name", "uuid"])

      puts "Create global permissions..."
      self.update_records(ExternalMasterDatabase::ExternalPermission, Permission, ["name", "description", "is_permission_project", "uuid"])

      #Update the latest update date information
      latest_saved_record = Version.last
      latest_repo_update = Home::latest_repo_update
      latest_saved_record.update_attributes(:local_latest_update => Time.now, :repository_latest_update => latest_repo_update, :comment => "Your Application latest update date")

    #  puts "\n\n"
    #  puts "Default data was successfully loaded. Enjoy !"
    #rescue Errno::ECONNREFUSED
    #  puts "\n\n\n"
    #  puts "!!! WARNING - Error: Default data was not loaded, please investigate"
    #  puts "Maybe run bundle exec rake sunspot:solr:start RAILS_ENV=your_environnement"
    #rescue Exception
    #  puts "\n\n"
    #  puts "!!! WARNING - Exception: Default data was not loaded, please investigate"
    #  puts "Maybe run db:create and db:migrate tasks."
    #end
  end

  def self.latest_repo_update
    dates = Array.new
    EXTERNAL_BASES.each do |table|
      if table == Attribute
        dates << Object::Attribute::attribute_updated_at
      else
        dates << table.all.map(&:updated_at)
      end
    end
    res = dates.flatten.compact.max
    res
  end

  def self.update_records(external, local, fields)
    loc_defined_rs_id = RecordStatus.find_by_name("Defined").id
    loc_custom_rs_id = RecordStatus.find_by_name("Custom").id
    loc_local_rs_id = RecordStatus.find_by_name("Local").id
    ext_defined_rs_id = ExternalMasterDatabase::ExternalRecordStatus.find_by_name("Defined").id
    ext_custom_rs_id = ExternalMasterDatabase::ExternalRecordStatus.find_by_name("Custom").id
    ext_local_rs_id = ExternalMasterDatabase::ExternalRecordStatus.find_by_name("Local").id

    externals = external.send(:defined, ext_defined_rs_id).send(:all)
    locals = local.send(:all)
    fields = fields + %w(change_comment)

    #We have to consider statuses listed in custom_status_to_consider
    custom_status_to_consider = AdminSetting.find_by_key("custom_status_to_consider")
    unless custom_status_to_consider.blank?
      statuses_to_consider = custom_status_to_consider.value.nil? ? [] : custom_status_to_consider.value.split(";")

      statuses_to_consider.each do |custom_value|
        #For each custom_value_to_consider, we find the corresponding record on Master with the same custom value
        ext_custom_record = external.find_by_record_status_id_and_custom_value(ext_custom_rs_id, custom_value)

        #If there is at least one custom record to consider
        unless ext_custom_record.nil?
          #We need to get the external record parent, then priority is given to the custom one
          ext_custom_record_parent = external.find_by_uuid(ext_custom_record.reference_uuid)

          #If the record has no parent, it will be added in the list to be consider for the update
          if ext_custom_record_parent.nil?
            externals.push(ext_custom_record)
          else
            #Else, the record has its parent (may be already consider for update)
            #In this case, priority is given to  custom one
            new_fields = fields + %w(record_status_id) - %w(uuid)

            externals.map! { |item|
              if item.uuid == ext_custom_record.reference_uuid
                new_fields.each do |field|
                  item.send("#{field}=", ext_custom_record.send(field.to_sym))
                end
                item
              else
                item
              end
            }
          end
        end
      end
    end

    externals.each do |ext|
      corresponding_local_rs_id = nil
      if ext.record_status_id == ext_defined_rs_id
        corresponding_local_rs_id = loc_defined_rs_id
      elsif ext.record_status_id == ext_custom_rs_id
        corresponding_local_rs_id = loc_custom_rs_id
      end

      if locals.map(&:uuid).include?(ext.uuid)
        #We only need to update Defined or Custom record (local and locally edited records will be kept intact)
        local_record = local.corresponding_local_record(ext.uuid, loc_local_rs_id).first

        unless local_record.nil?

          if local.to_s == "AdminSetting"
            if local_record.custom_value == "Locally edited"
              fields = fields - ["value"]
            end
          end

          fields.each do |field|
            local_record.update_attribute(:"#{field}", ext.send(field.to_sym))
          end

          #For Wbs-Activity-Elements, we need to rebuild the ancestry if it has changed
          if local.to_s == "WbsActivityElement"
            #Test if the element ancestry changed
            unless ext.ancestry.to_s.eql?(local_record.master_ancestry.to_s)
              local_ancestry = ""
              ext_ancestry = ext.ancestry
              unless ext_ancestry.nil?
                ext_ancestry_list = ext.ancestry.split('/')
                ext_ancestry_list.each do |ancestor|
                  ext_ancestor_uuid = ExternalMasterDatabase::ExternalWbsActivityElement.find_by_id(ancestor).uuid
                  ancestors <<  WbsActivityElement.find_by_uuid(ext_ancestor_uuid).id
                end
                if ancestors.length == 1
                  local_ancestry = ancestors.first.to_s
                elsif ancestors.length > 1
                  local_ancestry = ancestors.join('/')
                end
              end
              local_record.update_attributes(:ancestry => local_ancestry, :master_ancestry => ext.ancestry)
            end
          end

          local_record.update_attributes(:record_status_id => corresponding_local_rs_id, :change_comment => ext.change_comment)
        end

      else
        obj = local.send(:new)
        #for each fields
        fields.each do |field|
          #we update our local object with the external value
          obj.update_attribute(:"#{field}", ext.send(field.to_sym))
        end

        #Need to update link between Wbs-Activity and its elements
        case local.to_s
          when "WbsActivityElement"
            ext_wbs_activity_uuid = ExternalMasterDatabase::ExternalWbsActivity.find_by_id(ext.wbs_activity_id).uuid
            corresponding_wbs_activity_id = WbsActivity.find_by_uuid(ext_wbs_activity_uuid).id

            #build ancestry
            local_ancestry = ""
            ActiveRecord::Base.transaction do
              ancestors = []
              ext_ancestry = ext.ancestry
              unless ext_ancestry.nil?
                ext_ancestry_list = ext.ancestry.split('/')
                ext_ancestry_list.each do |ancestor|
                  ext_ancestor_uuid = ExternalMasterDatabase::ExternalWbsActivityElement.find_by_id(ancestor).uuid
                  ancestors <<  WbsActivityElement.find_by_uuid(ext_ancestor_uuid).id
                end
                if ancestors.length == 1
                  local_ancestry = ancestors.first.to_s
                elsif ancestors.length > 1
                  local_ancestry = ancestors.join('/')
                end
              end
            end
            #obj.update_attributes(:wbs_activity_id => corresponding_wbs_activity_id, :ancestry => local_ancestry.to_s, :master_ancestry => ext.ancestry.to_s)
            ActiveRecord::Base.connection.execute("UPDATE wbs_activity_elements SET wbs_activity_id = #{corresponding_wbs_activity_id}, ancestry = '#{local_ancestry}', master_ancestry = '#{ext.ancestry}' WHERE uuid = '#{ext.uuid}'")
          when "WbsActivityRatio"
            ext_wbs_activity_uuid = ExternalMasterDatabase::ExternalWbsActivity.find_by_id(ext.wbs_activity_id).uuid
            corresponding_wbs_activity_id = WbsActivity.find_by_uuid(ext_wbs_activity_uuid).id
            obj.update_attribute(:wbs_activity_id, corresponding_wbs_activity_id)

          when "WbsActivityRatioElement"
            ext_ratio_uuid = ExternalMasterDatabase::ExternalWbsActivityRatio.find_by_id(ext.wbs_activity_ratio_id).uuid
            ext_wbs_activity_element_uuid = ExternalMasterDatabase::ExternalWbsActivityElement.find_by_id(ext.wbs_activity_element_id).uuid
            local_wbs_activity_ratio_id = WbsActivityRatio.find_by_uuid(ext_ratio_uuid).id
            local_wbs_activity_element_id = WbsActivityElement.find_by_uuid(ext_wbs_activity_element_uuid).id
            obj.update_attributes(:wbs_activity_ratio_id => local_wbs_activity_ratio_id, :wbs_activity_element_id => local_wbs_activity_element_id)
        end

        obj.update_attributes(:record_status_id => corresponding_local_rs_id, :change_comment => ext.change_comment)
      end

    end
  end

  #calling create_records(ExternalMasterDatabase::ExternalLanguage, Language, ["name", "description"])
  #ext: external table name
  #loc: locale table name
  #fields: fields concerned
  def self.create_records(external, loc, fields)
    #Find correct record status id
    local_defined_rs_id = RecordStatus.find_by_name("Defined").id
    ext_rsid = ExternalMasterDatabase::ExternalRecordStatus.find_by_name("Defined").id
    ext_custom_rsid = ExternalMasterDatabase::ExternalRecordStatus.find_by_name("Custom").id

    #get all records (ex : ExternalMasterDatabase::ExternalLanguage.all)
    externals = external.send(:defined, ext_rsid).send(:all)

    #for each external records...
    externals.each do |ext|
      #...a record is instancied in the local table name
      obj = loc.send(:new)
      #for each fields
      fields.each do |field|
        #we update our local object with the external value
        obj.update_attribute(:"#{field}", ext.send(field.to_sym))
      end
      obj.update_attributes(:record_status_id => local_defined_rs_id, :change_comment => ext.change_comment)
    end
  end

  #Load MasterData from scratch
  def self.load_master_data!
    #begin
      record_status = ExternalMasterDatabase::ExternalRecordStatus.all
      record_status.each do |i|
        rs = RecordStatus.new(:name => i.name, :description => i.description, :uuid => i.uuid)
        rs.save(:validate => false)
        #rs.save
      end

      ext_defined_rs_id = ExternalMasterDatabase::ExternalRecordStatus.find_by_name("Defined").id
      local_defined_rs_id = RecordStatus.find_by_name("Defined").id

      puts "   - Record Status"  #Update record status to "Defined"
      record_statuses = RecordStatus.all
      record_statuses.each do |rs|
        rs.update_attribute(:record_status_id, local_defined_rs_id)
      end

      puts "   - Version"
      Version.create :comment => "No update data has been save"

      puts "   - ReferenceValue"
      self.create_records(ExternalMasterDatabase::ExternalReferenceValue, ReferenceValue, ["value", "uuid"])

      puts "   - Wbs Activity"
      self.create_records(ExternalMasterDatabase::ExternalWbsActivity, WbsActivity, ["name", "description", "uuid", "state"])

      puts "   - Wbs Activity Element"
      self.create_records(ExternalMasterDatabase::ExternalWbsActivityElement, WbsActivityElement, ["name", "description", "dotted_id", "uuid", "is_root"])

      puts "   - Wbs Activity Ratio"
      self.create_records(ExternalMasterDatabase::ExternalWbsActivityRatio, WbsActivityRatio, ["name", "description", "uuid"])

      puts "   - Wbs Activity Ratio Elements"
      self.create_records(ExternalMasterDatabase::ExternalWbsActivityRatioElement, WbsActivityRatioElement, ["ratio_value", "simple_reference", "multiple_references", "uuid"])

      puts "       - Rebuilding tree in progress..."
      activities = WbsActivity.all
      elements = WbsActivityElement.all
      ext_activities = ExternalMasterDatabase::ExternalWbsActivity.all
      ext_elements = ExternalMasterDatabase::ExternalWbsActivityElement.all
      ext_ratios = ExternalMasterDatabase::ExternalWbsActivityRatio.all
      ext_ratio_elements = ExternalMasterDatabase::ExternalWbsActivityRatioElement.all

      ext_activities.each do |ext_act|
        #Associate activity element to activity
        ext_elements.each do |ext_elt|
          if ext_act.id == ext_elt.wbs_activity_id and ext_act.record_status_id == ext_defined_rs_id
            act = WbsActivity.find_by_uuid(ext_act.uuid)

            #build ancestry
            local_ancestry = ""
            ActiveRecord::Base.transaction do
              ancestors = []
              ext_ancestry = ext_elt.ancestry
              unless ext_ancestry.nil?
                ext_ancestry_list = ext_elt.ancestry.split('/')
                ext_ancestry_list.each do |ancestor|
                  ext_ancestor_uuid = ExternalMasterDatabase::ExternalWbsActivityElement.find_by_id(ancestor).uuid
                  ancestors <<  WbsActivityElement.find_by_uuid(ext_ancestor_uuid).id
                end
                if ancestors.length == 1
                  local_ancestry = ancestors.first.to_s
                elsif ancestors.length > 1
                  local_ancestry = ancestors.join('/')
                end
              end
            end
            ActiveRecord::Base.connection.execute("UPDATE wbs_activity_elements SET wbs_activity_id = #{act.id}, ancestry = '#{local_ancestry}', master_ancestry = '#{ext_elt.ancestry}' WHERE uuid = '#{ext_elt.uuid}'")
          end
        end

        #Associate activity ratio to activity
        ext_ratios.each do |ext_ratio|
          if ext_act.id == ext_ratio.wbs_activity_id and ext_act.record_status_id == ext_defined_rs_id
            act = WbsActivity.find_by_uuid(ext_act.uuid)
            ActiveRecord::Base.connection.execute("UPDATE wbs_activity_ratios SET wbs_activity_id = #{act.id} WHERE uuid = '#{ext_ratio.uuid}'")
          end
        end
      end

      ext_ratios.each do |ext_ratio|
        ext_ratio_elements.each do |ext_ratio_element|
          if ext_ratio.id == ext_ratio_element.wbs_activity_ratio_id and ext_ratio.record_status_id == ext_defined_rs_id
            ratio = WbsActivityRatio.find_by_uuid(ext_ratio.uuid)
            ext_element = ExternalMasterDatabase::ExternalWbsActivityElement.find_by_id(ext_ratio_element.wbs_activity_element_id)
            element = WbsActivityElement.find_by_uuid(ext_element.uuid)
            ActiveRecord::Base.connection.execute("UPDATE wbs_activity_ratio_elements SET wbs_activity_ratio_id = #{ratio.id} WHERE uuid = '#{ext_ratio_element.uuid}'")
            ActiveRecord::Base.connection.execute("UPDATE wbs_activity_ratio_elements SET wbs_activity_element_id = #{element.id} WHERE uuid = '#{ext_ratio_element.uuid}'")
          end
        end
      end

      #activities.each do |a|
      #  WbsActivityElement::build_ancestry(elements, a.id)
      #end

      puts "   - Master Settings"
      self.create_records(ExternalMasterDatabase::ExternalMasterSetting, MasterSetting, ["key", "value", "uuid"])

      puts "   - Project areas"
      self.create_records(ExternalMasterDatabase::ExternalProjectArea, ProjectArea, ["name", "description", "uuid"])

      pjarea = ProjectArea.first

      puts "   - Project categories"
      self.create_records(ExternalMasterDatabase::ExternalProjectCategory, ProjectCategory, ["name", "description", "uuid"])

      puts "   - Platform categories"
      self.create_records(ExternalMasterDatabase::ExternalPlatformCategory, PlatformCategory, ["name", "description", "uuid"])

      puts "   - Acquisition categories"
      self.create_records(ExternalMasterDatabase::ExternalAcquisitionCategory, AcquisitionCategory, ["name", "description", "uuid"])

      puts "   - Attribute..."
      self.create_records(ExternalMasterDatabase::ExternalAttribute, Object::Attribute, ["name", "alias", "description", "attr_type", "aggregation", "uuid"])

      puts "   - Projestimate Icons"

      #Need to have same UUID as Master Instance Icons
      external_icons =  ExternalMasterDatabase::ExternalPeicon.send(:defined, ext_defined_rs_id).send(:all)

      external_icons.each do |ext_icon|
        if %w(Folder Link Undefined Default).include?(ext_icon.name)
          icon_name = ext_icon.name.downcase
          icon = Peicon.create(:name => ext_icon.name, :icon => File.new("#{Rails.root}/public/#{icon_name}.png"), :record_status_id => local_defined_rs_id)
          icon.update_attribute(:uuid, ext_icon.uuid)
        end
      end

      puts "   - WBS structure"
      self.create_records(ExternalMasterDatabase::ExternalWorkElementType, WorkElementType, ["name", "alias", "peicon_id", "uuid"])

      wet = WorkElementType.first

      puts "   - Currencies"
      self.create_records(ExternalMasterDatabase::ExternalCurrency, Currency, ["name", "description", "uuid"])

      puts "   - Language..."
      self.create_records(ExternalMasterDatabase::ExternalLanguage, Language, ["name", "locale", "uuid"])

      puts "   - Admin Settings"
      self.create_records(ExternalMasterDatabase::ExternalAdminSetting, AdminSetting, ["key", "value", "uuid"])

      puts "   - Auth Method"
      self.create_records(ExternalMasterDatabase::ExternalAuthMethod, AuthMethod, ["name", "server_name", "port", "base_dn", "certificate", "uuid"])

      puts "   - Admin user"
      #Create first user
      user = User.new(:first_name => "Administrator", :last_name => "Projestimate", :login_name => "admin", :initials => "ad", :email => "youremail@yourcompany.net", :auth_type => AuthMethod.first.id, :user_status => "active", :language_id => Language.first.id, :time_zone => "GMT")
      user.password = user.password_confirmation = "projestimate"
      user.save

      puts "   - Default groups"
      #Create default groups
      self.create_records(ExternalMasterDatabase::ExternalGroup, Group, ["name", "description", "uuid"])

      #Associated default user with group MasterAdmin
      user.group_ids = [Group.first.id]
      user.save

      puts "   - Labor categories"
      self.create_records(ExternalMasterDatabase::ExternalLaborCategory, LaborCategory, ["name", "description", "uuid"])
      laborcategory=LaborCategory.first

      puts "   - Activity categories"
      self.create_records(ExternalMasterDatabase::ExternalActivityCategory, ActivityCategory, ["name", "alias", "description", "uuid"])

      puts "   - Organizations"
      Organization.create(:name => "YourOrganization", :description => "This must be update to match your organization")
      Organization.create(:name => "Other", :description => "This could be used to group users that are not members of any orgnaization")
      organization = Organization.first

      puts "   - Demo project"
      #Create default project
      Project.create(:title => "Sample project", :description => "This is a sample project for demonstration purpose", :alias => "sample project", :state => "preliminary", :start_date => Time.now.strftime("%Y/%m/%d"), :is_model => false, :organization_id => organization.id, :project_area_id => pjarea.id, :project_category_id => ProjectCategory.first.id, :platform_category_id => PlatformCategory.first.id, :acquisition_category_id =>  AcquisitionCategory.first.id)
      project = Project.first

      #New default Pe-Wbs-Project
      pe_wbs_project_product  = project.pe_wbs_projects.build(:name => "#{project.title} WBS-Product - Product Breakdown Structure", :wbs_type => "Product")
      pe_wbs_project_activity = project.pe_wbs_projects.build(:name => "#{project.title} WBS-Activity - Activity breakdown Structure", :wbs_type => "Activity")

      folder = WorkElementType.find_by_alias("folder")

      if pe_wbs_project_product.save
        ##New root Pbs-Project-Element
        pbs_project_element = pe_wbs_project_product.pbs_project_elements.build(:name => "Root Element - #{project.title} WBS-Product", :is_root => true, :work_element_type_id => folder.id, :position => 0)
        pbs_project_element.save
        pe_wbs_project_product.save
      end

      if pe_wbs_project_activity.save
        ##New Root Wbs-Project-Element
        wbs_project_element = pe_wbs_project_activity.wbs_project_elements.build(:name => "Root Element - #{project.title} WBS-Activity", :is_root => true, :description => "WBS-Activity Root Element", :author_id => user.id)
        wbs_project_element.save
      end

      #Associated default user with sample project
      user.project_ids = [Project.first.id]
      user.save

      puts "   - Create project security level..."
      self.create_records(ExternalMasterDatabase::ExternalProjectSecurityLevel, ProjectSecurityLevel, ["name", "uuid"])

      puts "   - Create global permissions..."
      self.create_records(ExternalMasterDatabase::ExternalPermission, Permission, ["name", "description", "is_permission_project", "uuid"])

      puts "\n\n"
      puts "   - Default data was successfully loaded. Enjoy !"
    #rescue Errno::ECONNREFUSED
    #  puts "\n\n\n"
    #  puts "!!! WARNING - Error: Default data was not loaded, please investigate."
    #  puts "Maybe run bundle exec rake sunspot:solr:start RAILS_ENV=your_environnement."
    #rescue Exception
    #  puts "\n\n"
    #  puts "!!! WARNING - Exception: Default data was not loaded, please investigate..."
    #  puts "Maybe run db:create and db:migrate tasks."
    #end
  end
end
