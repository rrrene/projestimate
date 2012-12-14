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
  task :load_default_data_from_master_repo => :environment do

    print "\n You're about to install the default data on #{Rails.env} database. Do you want : \n
       1- Delete all data then reinstall default data -- Press 1 \n
       2- Reinstall default data and keep old data (recommended) -- Press 2 \n
       3- Do nothing and quit the prompt -- Press 3 or Ctrl + C \n
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


          load_data_from_master_repo!
        end
        i = false
      elsif response == '2'
        are_you_sure? do
          load_data_from_master_repo!
        end
        i = false
      elsif response == '3'
        puts "Nothing to do. Bye."
        i = false
      end
    end
  end
end

private
def load_data_from_master_repo!
  begin

  puts " Creating Master Parameters ..."

    puts "   - Master setting"
    ms = ExternalMasterDatabase::ExternalMasterSetting.all.map{|i| [i.key, i.value] }
    ms.each do |table_name|
      MasterSetting.create(:key => table_name[0], :value => table_name[1])
    end

    puts "   - Project areas"
    project_areas = ExternalMasterDatabase::ExternalProjectArea.all.map{|i| [i.name, i.description] }
    project_areas.each do |table_name|
      ProjectArea.create(:name => table_name[0], :description => table_name[1])
    end
    pjarea = ProjectArea.first

    puts "   - Project categories"
    project_categories = ExternalMasterDatabase::ExternalProjectCategory.all.map{|i| [i.name, i.description]}
    project_categories.each do |i|
      ProjectCategory.create(:name => i[0], :description => i[1])
    end

    puts "   - Platform categories"
    platform_categories = ExternalMasterDatabase::ExternalPlatformCategory.all.map{|i| [i.name, i.description]}
    platform_categories.each do |i|
      PlatformCategory.create(:name => i[0], :description => i[1])
    end

    puts "   - Acquisition categories"
    #Default acquisition category
    acquisition_categories = Array.new
    acquisition_categories = ExternalMasterDatabase::ExternalAcquisitionCategory.all.map{|i| [i.name, i.description]}
    acquisition_categories.each do |i|
      AcquisitionCategory.create(:name => i[0], :description => i[1])
    end

    puts "   - Attribute..."
    attributes = ExternalMasterDatabase::ExternalAttribute.all.map{|i| [i.name, i.alias, i.description, i.attr_type, i.aggregation] }
    attributes.each do |i|
      Attribute.create(:name => i[0], :alias => i[1], :description => i[2], :attr_type => i[3], :aggregation => i[4])
    end

    puts "   - Projestimate Icons"
    peicons = ExternalMasterDatabase::ExternalPeicon.all.map{|i| [i.name] }
    peicons.each do |i|
      Peicon.create(:name => i[0])
    end

    puts "   - WBS structure"
    wets = ExternalMasterDatabase::ExternalWorkElementType.all.map{|i| [i.name, i.alias, i.peicon_id] }
    wets.each do |i|
      WorkElementType.create(:name => i[0], :alias => i[1])
    end

    wet = WorkElementType.first

    puts "   - Currencies"
    curr = ExternalMasterDatabase::ExternalCurrency.all.map{|i| [i.name, i.alias, i.description] }
    curr.each do |i|
      Currency.create(:name => i[0], :alias => i[1], :description => i[2] )
    end

    puts "   - Language..."
    languages = ExternalMasterDatabase::ExternalLanguage.all.map{|i| [i.name, i.locale] }
    languages.each do |table_name|
      Language.create(:name => table_name[0], :locale => table_name[1])
    end

    puts "   - Currencies"
    curr = ExternalMasterDatabase::ExternalAdminSetting.all.map{|i| [i.key, i.value] }
    curr.each do |i|
      AdminSetting.create(:key => i[0], :value => i[1] )
    end

    puts "   - Auth Method"
    AuthMethod.create(:name => "Application", :server_name => "Not necessary", :port => 0, :base_dn => "Not necessary", :certificate => "false")

    puts "   - Admin user"
    #Create first user
    user = User.new(:first_name => "Administrator", :last_name => "Projestimate", :login_name => "admin", :initials => "ad", :email => "youremail@yourcompany.net", :auth_type => AuthMethod.first.id, :user_status => "active", :language_id => Language.first.id)
    user.password = user.password_confirmation = "projestimate"
    user.save

    puts "   - Default groups"
    #Create default groups
    Group.create(:name => "MasterAdmin")
    Group.create(:name => "Admin")
    Group.create(:name => "Everyone")

    #Associated default user with group MasterAdmin
    user.group_ids = [Group.first.id]
    user.save

    puts "   - Labor categories"
    labor_categories = ExternalMasterDatabase::ExternalLaborCategory.all.map{|i| [i.name, i.description] }
    labor_categories.each do |i|
      LaborCategory.create(:name => i[0], :description => i[1])
    end
    laborcategory=LaborCategory.first

    puts "   - Activity categories"
    #Default actitity category
    activity_categories = ExternalMasterDatabase::ExternalActivityCategory.all.map{|i| [i.name, i.alias, i.description] }
        activity_categories.each do |i|
        ActivityCategory.create(:name => i[0], :alias => i[1], :description => i[2])
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
      ProjectSecurityLevel.create(:name => i[0])
    end

    puts "Create global permissions..."
    #Default permissions
    permissions = ExternalMasterDatabase::ExternalPermission.all.map{|i| [i.name, i.description, i.is_permission_project] }
    permissions.each do |i|
      Permission.create(:name => String.keep_clean_space(i[0]), :description => i[1], :is_permission_project => i[2])
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