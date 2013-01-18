class Home < ActiveRecord::Base
  include ExternalMasterDatabase

  def self.update_master_data!
    puts "Updating from Master Data"
    begin
      puts "Master Settings"
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
      self.update_records(ExternalMasterDatabase::ExternalPeicon, Peicon, ["name", "uuid"])

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

      puts "\n\n"
      puts "Default data was successfully loaded. Enjoy !"
    rescue Errno::ECONNREFUSED
      puts "\n\n\n"
      puts "!!! WARNING - Error: Default data was not loaded, please investigate"
      puts "Maybe run bundle exec rake sunspot:solr:start RAILS_ENV=your_environnement"
      flash["Error"] = "!!! WARNING - Error: Default data was not loaded, please investigate. <br /> Maybe run bundle exec rake sunspot:solr:start RAILS_ENV=your_environnement"
    rescue Exception
      puts "\n\n"
      puts "!!! WARNING - Exception: Default data was not loaded, please investigate"
      puts "Maybe run db:create and db:migrate tasks."
      flash["Error"] = "!!! WARNING - Exception: Default data was not loaded, please investigate... <br /> Maybe run db:create and db:migrate tasks."
    end
  end

  def self.latest_repo_update
    dates = Array.new
    [ExternalLanguage, ExternalAttribute].each do |table|
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
    ext_defined_rs_id = ExternalMasterDatabase::ExternalRecordStatus.find_by_name("Defined").id
    ext_custom_rs_id = ExternalMasterDatabase::ExternalRecordStatus.find_by_name("Custom").id

    externals = external.send(:defined, ext_defined_rs_id).send(:all)
    locals = local.send(:all)

    #We have to consider statuses listed in custom_status_to_consider
    custom_status_to_consider = AdminSetting.find_by_key("custom_status_to_consider")
    unless custom_status_to_consider.nil?
      statuses_to_consider = custom_status_to_consider.value.nil? ? [] : custom_status_to_consider.value.split(";")

      first_custom_value = statuses_to_consider.first
      custom_record = external.find_by_record_status_id_and_custom_value(ext_custom_rs_id, first_custom_value)

      #Get the custom record parent index from defined record
      index = custom_record.nil? ? nil : externals.index(custom_record.parent)
      custom_parent_record = index.nil? ? nil : externals[index]
      unless custom_parent_record.nil?
        custom_parent_record_uuid = custom_parent_record.uuid #temporary save the parent uuid
        fields.each do |field|
          #Update the defined record with the Custom one value
          custom_parent_record.update_attribute(:"#{field}", custom_record.send(field.to_sym))
        end
        custom_parent_record.update_attribute(:uuid, custom_parent_record_uuid)
        externals[index] = custom_parent_record
      end
    end

    externals.each do |ext|
      corresponding_local_rs_id = nil
      if ext.record_status_id == ext_defined_rs_id
        corresponding_local_rs_id = loc_defined_rs_id
      elsif ext.record_status_id == ext_custom_rs_id
        corresponding_local_rs_id = loc_custom_rs_id
      end



      local_record = local.find_by_uuid(ext.uuid)
      unless local_record.nil?
        fields.each do |field|
          local_record.update_attribute(:"#{field}", ext.send(field.to_sym))
        end
        local_record.update_attributes(:record_status_id => corresponding_local_rs_id, :change_comment => ext.change_comment)
      end

      unless locals.map(&:uuid).include?(ext.uuid)
        #self.create_records(external, local, fields)
        obj = local.send(:new)
        #for each fields
        fields.each do |field|
          #we update our local object with the external value
          obj.update_attribute(:"#{field}", ext.send(field.to_sym))
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
    rsid = RecordStatus.find_by_name("Defined").id
    ext_rsid = ExternalMasterDatabase::ExternalRecordStatus.find_by_name("Defined").id
    ext_custom_rsid = ExternalMasterDatabase::ExternalRecordStatus.find_by_name("Custom").id

    #get all records (ex : ExternalMasterDatabase::ExternalLanguage.all)
    externals = external.send(:defined, ext_rsid).send(:all)

    #We have to consider statuses listed in custom_status_to_consider
    #custom_status_to_consider = AdminSetting.find_by_key("custom_status_to_consider")
    #unless custom_status_to_consider.nil?
    #  statuses_to_consider = custom_status_to_consider.value.nil? ? [] : custom_status_to_consider.value.split(";")
    #
    #  first_custom_value = statuses_to_consider.first
    #  custom_record = external.find_by_record_status_id_and_custom_value(ext_custom_rsid, first_custom_value)
    #
    #  #Get the custom record parent index from defined record
    #  index = custom_record.nil? ? nil : externals.index(custom_record.parent)
    #  custom_parent_record = index.nil? ? nil : externals[index]
    #  unless custom_parent_record.nil?
    #    custom_parent_record_uuid = custom_parent_record.uuid #temporary save the parent uuid
    #    custom_parent_record_ref = custom_parent_record.ref
    #
    #    fields.each do |field|
    #      #Update the defined record with the Custom one value
    #      custom_parent_record.update_attribute(:"#{field}", custom_record.send(field.to_sym))
    #    end
    #    custom_parent_record.update_attribute(:uuid, custom_parent_record_uuid)
    #    externals[index] = custom_parent_record
    #  end
    #end

    #for each external records...
    externals.each do |ext|
      #...a record is instancied in the local table name
      obj = loc.send(:new)
      #for each fields
      fields.each do |field|
        #we update our local object with the external value
        obj.update_attribute(:"#{field}", ext.send(field.to_sym))
      end
      obj.update_attributes(:record_status_id => rsid, :change_comment => ext.change_comment)
    end
  end

  def self.load_master_data!
    begin
      record_status = ExternalMasterDatabase::ExternalRecordStatus.all
      record_status.each do |i|
        rs = RecordStatus.new(:name => i.name, :description => i.description)
        rs.save(:validate => false)
      end

      puts "Master Settings"
      self.create_records(ExternalMasterDatabase::ExternalMasterSetting, MasterSetting, ["key", "value", "uuid"])

      puts "   - Project areas"
      self.create_records(ExternalMasterDatabase::ExternalProjectArea, ProjectArea, ["name", "description", "uuid"])

      pjarea = ProjectArea.first

      puts "   - Project categories"
      self.create_records(ExternalMasterDatabase::ExternalProjectCategory, ProjectCategory, ["name", "description", "uuid"])

      puts "   - Platform categories"
      self.create_records(ExternalMasterDatabase::ExternalPlatformCategory, PlatformCategory, ["name", "description", "uuid"])

      puts "   - Acquisition categories"
      #Default acquisition category
      self.create_records(ExternalMasterDatabase::ExternalAcquisitionCategory, AcquisitionCategory, ["name", "description", "uuid"])

      puts "   - Attribute..."
      self.create_records(ExternalMasterDatabase::ExternalAttribute, Object::Attribute, ["name", "alias", "description", "attr_type", "aggregation", "uuid"])

      puts "   - Projestimate Icons"
      self.create_records(ExternalMasterDatabase::ExternalPeicon, Peicon, ["name", "uuid"])

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
      user = User.new(:first_name => "Administrator", :last_name => "Projestimate", :login_name => "admin", :initials => "ad", :email => "youremail@yourcompany.net", :auth_type => AuthMethod.first.id, :user_status => "active", :language_id => Language.first.id)
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

      puts " Creating  organizations..."
      Organization.create(:name => "YourOrganization", :description => "This must be update to match your organization")
      Organization.create(:name => "Other", :description => "This could be used to group users that are not members of any orgnaization")
      organization = Organization.first

      puts "   - Demo project"
      #Create default project
      Project.create(:title => "Sample project", :description => "This is a sample project for demonstration purpose", :alias => "sample project", :state => "preliminary", :start_date => Time.now.strftime("%Y/%m/%d"), :is_model => false, :organization_id => organization.id, :project_area_id => pjarea.id, :project_category_id => ProjectCategory.first.id, :platform_category_id => PlatformCategory.first.id, :acquisition_category_id =>  AcquisitionCategory.first.id)
      project = Project.first

      #Associated default user with sample project
      user.project_ids = [Project.first.id]
      user.save

      #Create default wbs associated with previous project
      PeWbsProject.create(:project_id => project.id)
      pe_wbs_project = PeWbsProject.first

      #Create root component
      component = Component.create(:is_root => true, :pe_wbs_project_id => pe_wbs_project.id, :work_element_type_id => wet.id, :position => 0, :name => "Root folder")
      component = Component.first

      puts "Create project security level..."
      self.create_records(ExternalMasterDatabase::ExternalProjectSecurityLevel, ProjectSecurityLevel, ["name", "uuid"])

      puts "Create global permissions..."
      self.create_records(ExternalMasterDatabase::ExternalPermission, Permission, ["name", "description", "is_permission_project", "uuid"])

      puts "\n\n"
      puts "Default data was successfully loaded. Enjoy !"
    rescue Errno::ECONNREFUSED
      puts "\n\n\n"
      puts "!!! WARNING - Error: Default data was not loaded, please investigate."
      puts "Maybe run bundle exec rake sunspot:solr:start RAILS_ENV=your_environnement."
      flash["Error"] = "!!! WARNING - Error: Default data was not loaded, please investigate. <br /> Maybe run bundle exec rake sunspot:solr:start RAILS_ENV=your_environnement"
    rescue Exception
      puts "\n\n"
      puts "!!! WARNING - Exception: Default data was not loaded, please investigate..."
      puts "Maybe run db:create and db:migrate tasks."
      flash["Error"] = "!!! WARNING - Exception: Default data was not loaded, please investigate... <br /> Maybe run db:create and db:migrate tasks."
    end
  end
end
