class Home < ActiveRecord::Base
  def self.update_master_data!
    begin
        ext_defined_rs_id = ExternalMasterDatabase::ExternalRecordStatus.find_by_name("Defined").id
        loc_defined_rs_id = RecordStatus.find_by_name("Defined").id

        puts " Updating Master Parameters ..."

        puts "   - Record Status"

        exts = ExternalMasterDatabase::ExternalRecordStatus.all
        locals = RecordStatus.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
              loc.update_attribute(:description, ext.child.description)
            end

            if ext.record_status_id == ext_defined_rs_id and !ext.ref.nil?
             if !locals.map(&:uuid).include?(ext.ref)
               ms = RecordStatus.create(:name => ext.name, :description => ext.description, :record_status_id => loc_defined_rs_id)
               ms.update_attribute("uuid", ext.uuid)
             end
           end
          end
        end

        puts "   - Master setting"
        exts = ExternalMasterDatabase::ExternalMasterSetting.all
        locals = MasterSetting.all

        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:key, ext.child.key)
              loc.update_attribute(:value, ext.child.value)
            end
          end

          if ext.record_status_id == ext_defined_rs_id and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              ms = MasterSetting.create(:key => ext.key, :value => ext.value, :record_status_id => loc_defined_rs_id)
              ms.update_attribute("uuid", ext.uuid)
            end
          end
        end

        puts "   - Project areas"
        exts = ExternalMasterDatabase::ExternalProjectArea.all
        locals = ProjectArea.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
              loc.update_attribute(:description, ext.description)
            end
          end

          if ext.record_status_id == ext_defined_rs_id and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              pa = ProjectArea.create(:name => ext.name, :description => ext.description, :record_status_id => loc_defined_rs_id)
              pa.update_attribute("uuid", ext.uuid)
            end
          end

        end

        puts "   - Project categories"
        exts = ExternalMasterDatabase::ExternalProjectCategory.all
        locals = ProjectCategory.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid and !ext.ref.nil?
              if !locals.map(&:uuid).include?(ext.ref)
                loc.update_attribute(:name, ext.child.name)
                loc.update_attribute(:description, ext.child.description)
              end
            end
          end

          if ext.record_status_id == ext_defined_rs_id and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              pc = ProjectCategory.create(:name => ext.name, :description => ext.description, :record_status_id => loc_defined_rs_id)
              pc.update_attribute("uuid", ext.uuid)
            end
          end
        end

        puts "   - Platform categories"
        exts = ExternalMasterDatabase::ExternalPlatformCategory.all
        locals = PlatformCategory.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
              loc.update_attribute(:description, ext.child.description)
            end
          end

          if ext.record_status_id == ext_defined_rs_id and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              pc = PlatformCategory.create(:name => ext.name, :description => ext.description, :record_status_id => loc_defined_rs_id)
              pc.update_attribute("uuid", ext.uuid)
            end
          end
        end

        puts "   - Acquisition categories"
        #Default acquisition category
        exts = ExternalMasterDatabase::ExternalAcquisitionCategory.all
        locals = AcquisitionCategory.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
              loc.update_attribute(:description, ext.child.description)
            end
          end

          if ext.record_status_id == ext_defined_rs_id and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              acq = AcquisitionCategory.create(:name => ext.name, :description => ext.description, :record_status_id => loc_defined_rs_id)
              acq.update_attribute("uuid", ext.uuid)
            end
          end
        end

        puts "   - Projestimate Icons"
        exts = ExternalMasterDatabase::ExternalPeicon.all
        locals = Peicon.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
            end
          end

          if ext.record_status_id == ext_defined_rs_id and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              icn = Peicon.create(:name => ext.name, :record_status_id => loc_defined_rs_id)
              icn.update_attribute("uuid", ext.uuid)
            end
          end
        end

        puts "   - Attributes"
        exts = ExternalMasterDatabase::ExternalAttribute.all
        locals = Object::Attribute.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
              loc.update_attribute(:description, ext.child.description)
              loc.update_attribute(:alias, ext.child.alias)
              loc.update_attribute(:attr_type, ext.child.attr_type)
              loc.update_attribute(:aggregation, ext.child.aggregation)
            end
          end
          if ext.record_status_id == ext_defined_rs_id and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              a = Attribute.create(:name => ext.name, :description => ext.description, :alias => ext.alias, :attr_type => ext.attr_type, :aggregation => ext.aggregation, :record_status_id => loc_defined_rs_id)
              a.update_attribute("uuid", ext.uuid)
            end
          end
        end

        puts "   - WBS structure"
        exts = ExternalMasterDatabase::ExternalWorkElementType.all
        locals = WorkElementType.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
              loc.update_attribute(:alias, ext.child.alias)
            end
          end

          if ext.record_status_id == ext_defined_rs_id  and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              wet = WorkElementType.create(:name => ext.name, :alias => ext.alias, :record_status_id => loc_defined_rs_id)
              wet.update_attribute("uuid", ext.uuid)
            end
          end
        end

        puts "   - Language"
        exts = ExternalMasterDatabase::ExternalLanguage.all
        locals = Language.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
              loc.update_attribute(:locale, ext.child.locale)
            end
          end
          if ext.record_status_id == ext_defined_rs_id  and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              l = Language.create(:name => ext.name, :locale => ext.locale, :record_status_id => loc_defined_rs_id)
              l.update_attribute("uuid", ext.uuid)
            end
          end
        end

        #puts "   - Admin Setting"
        #exts = ExternalMasterDatabase::ExternalAdminSetting.all
        #locals = AdminSetting.all
        #exts.each do |ext|
        #  locals.each do |loc|
        #    if ext.ref == loc.uuid
        #      loc.update_attribute(:key, ext.child.key)
        #      loc.update_attribute(:value, ext.child.value)
        #    end
        #  end
        #  if ext.record_status_id == ext_defined_rs_id  and !ext.ref.nil?
        #    if !locals.map(&:uuid).include?(ext.ref)
        #      as = AdminSetting.create(:key => ext.key, :value => ext.value, :record_status_id => loc_defined_rs_id)
        #      as.update_attribute("uuid", ext.uuid)
        #    end
        #  end
        #end

        puts "   - Auth Method"
        exts = ExternalMasterDatabase::ExternalAuthMethod.all
        locals = AuthMethod.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
              loc.update_attribute(:server_name, ext.child.server_name)
              loc.update_attribute(:port, ext.child.port)
              loc.update_attribute(:base_dn, ext.child.base_dn)
              loc.update_attribute(:certificate, ext.child.certificate)
            end
          end

          if ext.record_status_id == ext_defined_rs_id and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              am = AuthMethod.create(:name => ext.name, :server_name => ext.server_name, :port => ext.port, :base_dn => ext.base_dn, :certificate => ext.certificate, :record_status_id => loc_defined_rs_id)
              am.update_attribute("uuid", ext.uuid)
            end
          end
        end
        #
        puts "   - Default groups"
        #Update default groups
        exts = ExternalMasterDatabase::ExternalGroup.all
        locals = Group.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
              loc.update_attribute(:description, ext.child.description)
            end
          end

          if ext.record_status_id == ext_defined_rs_id and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              gp = Group.create(:name => ext.name, :description => ext.description, :record_status_id => loc_defined_rs_id)
              gp.update_attribute("uuid", ext.uuid)
            end
          end
        end


        puts "   - Labor categories"
        exts = ExternalMasterDatabase::ExternalLaborCategory.all
        locals = LaborCategory.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
              loc.update_attribute(:description, ext.child.description)
            end
          end

          if ext.record_status_id == ext_defined_rs_id  and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              lc = LaborCategory.create(:name => ext.name, :description => ext.description, :record_status_id => loc_defined_rs_id)
              lc.update_attribute("uuid", ext.uuid)
            end
          end
        end

        puts "   - Activity categories"
        #Default actitity category
        exts = ExternalMasterDatabase::ExternalActivityCategory.all
        locals = ActivityCategory.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
              loc.update_attribute(:description, ext.child.description)
            end
          end

          if ext.record_status_id == ext_defined_rs_id  and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              ac = ActivityCategory.create(:name => ext.name, :description => ext.description, :record_status_id => loc_defined_rs_id)
              ac.update_attribute("uuid", ext.uuid)
            end
          end
        end

        puts "   - Update project security level"
        locals = ProjectSecurityLevel.all
        exts =  ExternalMasterDatabase::ExternalProjectSecurityLevel.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
            end
          end

          if ext.record_status_id == ext_defined_rs_id and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              psl = ProjectSecurityLevel.create(:name => ext.name, :record_status_id => loc_defined_rs_id)
              psl.update_attribute("uuid", ext.uuid)
            end
          end
        end

        puts "   - Update global permissions"
        locals = Permission.all
        exts = ExternalMasterDatabase::ExternalPermission.all
        exts.each do |ext|
          locals.each do |loc|
            if ext.ref == loc.uuid
              loc.update_attribute(:name, ext.child.name)
              loc.update_attribute(:description, ext.child.description)
              loc.update_attribute(:is_permission_project, ext.child.is_permission_project)
            end
          end

          if ext.record_status_id == ext_defined_rs_id and !ext.ref.nil?
            if !locals.map(&:uuid).include?(ext.ref)
              psl = Permission.create(:name => ext.name, :description => ext.description, :is_permission_project => ext.is_permission_project, :record_status_id => loc_defined_rs_id)
              psl.update_attribute("uuid", ext.uuid)
            end
          end
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
end
