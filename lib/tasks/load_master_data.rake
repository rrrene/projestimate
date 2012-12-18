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
  desc "Load default data from remote repository"
  task :load_master_data => :environment do

    print "\n You're about to install the default data on #{Rails.env} database. Do you want : \n
       1- Delete all then Re-install default data -- Press 1 \n
       2- Do nothing and quit the prompt -- Press 3 or Ctrl + C \n
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
          ProjectSecurity.delete_all
          ProjectSecurityLevel.delete_all
          Permission.delete_all
          Currency.delete_all
          Language.delete_all
          Peicon.delete_all
          AuthMethod.delete_all

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


          load_master_data!
        end
        i = false
      elsif response == '2'
        puts "Nothing to do. Bye."
        i = false
      end
    end
  end
end

private
def load_master_data!
  #begin

  puts " Creating Master Parameters ..."
    record_status = ExternalMasterDatabase::ExternalRecordStatus.all.map{|i| [i.name, i.description] }
    record_status.each do |i|
      RecordStatus.create(:name => i[0], :description => i[1] )
    end

    #Find orrect record status id
    #rsid = RecordStatus.find_by_name("Defined").id

    puts "   - Master setting"
    ms = ExternalMasterDatabase::ExternalMasterSetting.all.map{|i| [i.key, i.value, i.uuid, i.record_status_id, i.custom_value] }
    ms.each do |i|
      MasterSetting.create(:key => i[0], :value => i[1], :uuid => i[2], :record_status_id => i[3], :custom_value => i[4] )
    end

    puts "   - Project areas"
    project_areas = ExternalMasterDatabase::ExternalProjectArea.all.map{|i| [i.name, i.description, i.uuid, i.record_status_id, i.custom_value] }
    project_areas.each do |i|
      ProjectArea.create(:name => i[0], :description => i[1], :uuid => i[2], :record_status_id => i[3], :custom_value => i[4])
    end
    pjarea = ProjectArea.first

    puts "   - Project categories"
    project_categories = ExternalMasterDatabase::ExternalProjectCategory.all.map{|i| [i.name, i.description, i.uuid, i.record_status_id, i.custom_value]}
    project_categories.each do |i|
      ProjectCategory.create(:name => i[0], :description => i[1],  :uuid => i[2], :record_status_id => i[3], :custom_value => i[4])
    end

    puts "   - Platform categories"
    platform_categories = ExternalMasterDatabase::ExternalPlatformCategory.all.map{|i| [i.name, i.description, i.uuid, i.record_status_id, i.custom_value]}
    platform_categories.each do |i|
      PlatformCategory.create(:name => i[0], :description => i[1],  :uuid => i[2], :record_status_id => i[3], :custom_value => i[4])
    end

    puts "   - Acquisition categories"
    #Default acquisition category
    acquisition_categories = Array.new
    acquisition_categories = ExternalMasterDatabase::ExternalAcquisitionCategory.all.map{|i| [i.name, i.description, i.uuid, i.record_status_id, i.custom_value]}
    acquisition_categories.each do |i|
      AcquisitionCategory.create(:name => i[0], :description => i[1],  :uuid => i[2], :record_status_id => i[3], :custom_value => i[4])
    end

    puts "   - Attribute..."
    attributes = ExternalMasterDatabase::ExternalAttribute.all.map{|i| [i.name, i.alias, i.description, i.attr_type, i.aggregation, i.uuid, i.record_status_id, i.custom_value] }
    attributes.each do |i|
      Attribute.create(:name => i[0], :alias => i[1], :description => i[2], :attr_type => i[3], :aggregation => i[4], :uuid => i[5], :record_status_id => i[6], :custom_value => i[7])
    end

    puts "   - Projestimate Icons"
    peicons = ExternalMasterDatabase::ExternalPeicon.all.map{|i| [i.name, i.uuid, i.record_status_id, i.custom_value] }
    peicons.each do |i|
      Peicon.create(:name => i[0], :uuid => i[1], :record_status_id => i[2], :custom_value => i[3])
    end

    puts "   - WBS structure"
    wets = ExternalMasterDatabase::ExternalWorkElementType.all.map{|i| [i.name, i.alias, i.peicon_id, i.uuid, i.record_status_id, i.custom_value] }
    wets.each do |i|
      WorkElementType.create(:name => i[0], :alias => i[1], :uuid => i[2], :record_status_id => i[3], :custom_value => i[4])
    end

    wet = WorkElementType.first

    puts "   - Currencies"
    curr = ExternalMasterDatabase::ExternalCurrency.all.map{|i| [i.name, i.alias, i.description, i.uuid, i.record_status_id, i.custom_value] }
    curr.each do |i|
      Currency.create(:name => i[0], :alias => i[1], :description => i[2], :uuid => i[3], :record_status_id => i[4], :custom_value => i[5] )
    end

    puts "   - Language..."
    languages = ExternalMasterDatabase::ExternalLanguage.all.map{|i| [i.name, i.locale, i.uuid, i.record_status_id, i.custom_value] }
    languages.each do |i|
      Language.create(:name => i[0], :locale => i[1], :uuid => i[2], :record_status_id => i[3], :custom_value => i[4])
    end

    puts "   - Currencies"
    curr = ExternalMasterDatabase::ExternalAdminSetting.all.map{|i| [i.key, i.value, i.uuid, i.record_status_id, i.custom_value] }
    curr.each do |i|
      AdminSetting.create(:key => i[0], :value => i[1], :uuid => i[2], :record_status_id => i[3], :custom_value => i[4] )
    end

    puts "   - Auth Method"
    am = ExternalMasterDatabase::ExternalAuthMethod.all.map{|i| [i.name, i.server_name, i.port, i.base_dn, i.certificate, i.uuid, i.record_status_id, i.custom_value] }
    am.each do |i|
      AuthMethod.create(:name => i[0], :server_name => i[1], :port => i[2], :base_dn => i[3], :certificate => i[4], :uuid => i[2], :record_status_id => i[3], :custom_value => i[4])
    end

    puts "   - Admin user"
    #Create first user
    user = User.new(:first_name => "Administrator", :last_name => "Projestimate", :login_name => "admin", :initials => "ad", :email => "youremail@yourcompany.net", :auth_type => AuthMethod.first.id, :user_status => "active", :language_id => Language.first.id)
    user.password = user.password_confirmation = "projestimate"
    user.save

    puts "   - Default groups"
    #Create default groups
    grps = ExternalMasterDatabase::ExternalGroup.all.map{|i| [i.name, i.description, i.uuid, i.record_status_id, i.custom_value] }
    grps.each do |i|
      Group.create(:name => i[0], :description => i[1], :uuid => i[2], :record_status_id => i[3], :custom_value => i[4])
    end

    #Associated default user with group MasterAdmin
    user.group_ids = [Group.first.id]
    user.save

    puts "   - Labor categories"
    labor_categories = ExternalMasterDatabase::ExternalLaborCategory.all.map{|i| [i.name, i.description, i.uuid, i.record_status_id, i.custom_value] }
    labor_categories.each do |i|
      LaborCategory.create(:name => i[0], :description => i[1], :uuid => i[2], :record_status_id => i[3], :custom_value => i[4])
    end
    laborcategory=LaborCategory.first

    puts "   - Activity categories"
    #Default actitity category
    activity_categories = ExternalMasterDatabase::ExternalActivityCategory.all.map{|i| [i.name, i.alias, i.description, i.uuid, i.record_status_id, i.custom_value] }
        activity_categories.each do |i|
        ActivityCategory.create(:name => i[0], :alias => i[1], :description => i[2], :uuid => i[3], :record_status_id => i[4], :custom_value => i[5])
      end

    puts " Creating  organizations..."
    Organization.create(:name => "YourOrganization", :description => "This must be update to match your organization")
    Organization.create(:name => "Other", :description => "This could be used to group users that are not members of any orgnaization")
    organization = Organization.first


    #puts "   - Inflation"
    #Inflation.create(:organization_id => organization.id, :year => Time.now.strftime("%Y"), :labor_inflation => "1.0", :material_inflation => "1.0", :description => "TBD" )

    #puts "   - Organization Labor Category"
    #OrganizationLaborCategory.create(:labor_category_id => laborcategory, :organization_id => organization, :name => laborcategory.name)

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
    project_security_levels =  ExternalMasterDatabase::ExternalProjectSecurityLevel.all.map(&:name)
    project_security_levels.each do |i|
      ProjectSecurityLevel.create(:name => i[0], :uuid => i[1], :record_status_id => i[2], :custom_value => i[3])
    end

    puts "Create global permissions..."
    #Default permissions
    permissions = ExternalMasterDatabase::ExternalPermission.all.map{|i| [i.name, i.description, i.is_permission_project, i.uuid, i.record_status_id, i.custom_value] }
    permissions.each do |i|
      Permission.create(:name => String.keep_clean_space(i[0]), :description => i[1], :is_permission_project => i[2], :uuid => i[3], :record_status_id => i[4], :custom_value => i[5])
    end

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