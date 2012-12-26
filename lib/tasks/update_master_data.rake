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
  task :update_master_data => :environment do
    #
    #print "\n You're about to update default data on #{Rails.env} database. Do you want : \n
    #   1- Update existing default data -- Press 1 \n
    #   2- Do nothing and quit the prompt -- Press 3 or Ctrl + C \n
    #\n"
    #
    #i = true
    #while i do
    #  STDOUT.flush
    #  response = STDIN.gets.chomp!
    #
    #  if response == '1'
    #    are_you_sure? do
          update_master_data!
    #    end
    #    i = false
    #  elsif response == '2'
    #    puts "Nothing to do. Bye."
    #    i = false
    #  end
    #end
  end
end

private
def update_master_data!
  #begin
      puts " Updating Master Parameters ..."
      exts = ExternalMasterDatabase::ExternalRecordStatus.all.map{|i| [i.name, i.description, i.uuid, i.record_status_id, i.custom_value] }
      locals = RecordStatus.all
      exts.each do |ext|
          locals.each do |loc|
            if ext[2] == loc.uuid
              loc.update_attributes({:name => ext[0], :description => ext[1]})
            end
          end
        end

      puts "   - Master setting"
      exts = ExternalMasterDatabase::ExternalMasterSetting.all.map{|i| [i.key, i.value, i.uuid, i.record_status_id, i.custom_value] }
      locals = MasterSetting.all
      exts.each do |ext|
          locals.each do |loc|
            if ext[2] == loc.uuid
              loc.update_attributes({:key => ext[0], :value => ext[1]})
            end
          end
        end

      puts "   - Project areas"
      exts = ExternalMasterDatabase::ExternalProjectArea.all.map{|i| [i.name, i.description, i.uuid, i.record_status_id, i.custom_value] }
      locals = ProjectArea.all
      exts.each do |ext|
          locals.each do |loc|
            if ext[2] == loc.uuid
              loc.update_attributes({:name => ext[0], :description => ext[1]})
            end
          end
        end

      puts "   - Project categories"
      exts = ExternalMasterDatabase::ExternalProjectCategory.all.map{|i| [i.name, i.description, i.uuid, i.record_status_id, i.custom_value]}
      locals = ProjectCategory.all
      exts.each do |ext|
          locals.each do |loc|
            if ext[2] == loc.uuid
              loc.update_attributes({:name => ext[0], :description => ext[1]})
            end
          end
      end

      puts "   - Platform categories"
      exts = ExternalMasterDatabase::ExternalPlatformCategory.all.map{|i| [i.name, i.description, i.uuid, i.record_status_id, i.custom_value]}
      locals = PlatformCategory.all
      exts.each do |ext|
          locals.each do |loc|
            if ext[5] == loc.uuid
              loc.update_attributes({:name => ext[0], :description => ext[1]})
            end
          end
        end

      puts "   - Acquisition categories"
      #Default acquisition category
      exts = ExternalMasterDatabase::ExternalAcquisitionCategory.all.map{|i| [i.name, i.description, i.uuid, i.record_status_id, i.custom_value]}
      locals = AcquisitionCategory.all
      exts.each do |ext|
          locals.each do |loc|
            if ext[2] == loc.uuid
              loc.update_attributes({:name => ext[0], :description => ext[1]})
            end
          end
        end

      puts "   - Projestimate Icons"
      exts = ExternalMasterDatabase::ExternalPeicon.all.map{|i| [i.name, i.uuid, i.record_status_id, i.custom_value] }
      locals = Peicon.all
      exts.each do |ext|
          locals.each do |loc|
            if ext[1] == loc.uuid
              loc.update_attributes({:name => ext[0]})
            end
          end
        end

      puts "   - Attributes"
      exts = ExternalMasterDatabase::ExternalAttribute.all.map{|i| [i.name, i.alias, i.description, i.attr_type, i.aggregation, i.uuid, i.record_status_id, i.custom_value] }
      locals = Attribute.all
      exts.each do |ext|
        locals.each do |loc|
          if ext[5] == loc.uuid
            loc.update_attributes({:name => ext[0], :alias => ext[1], :description => ext[2], :attr_type => ext[3], :aggregation => ext[4]})
          end
        end
      end

      puts "   - WBS structure"
      exts = ExternalMasterDatabase::ExternalWorkElementType.all.map{|i| [i.name, i.alias, i.peicon_id, i.uuid, i.record_status_id, i.custom_value] }
      locals = WorkElementType.all
      exts.each do |ext|
        locals.each do |loc|
          if ext[3] == loc.uuid
            loc.update_attributes({:name => ext[0], :alias => ext[1]})
          end
        end
      end

      puts "   - Currencies"
      exts = ExternalMasterDatabase::ExternalCurrency.all.map{|i| [i.name, i.alias, i.description, i.uuid, i.record_status_id, i.custom_value] }
      locals = Currency.all
      exts.each do |ext|
        locals.each do |loc|
          if ext[3] == loc.uuid
            loc.update_attributes({:name => ext[0], :alias => ext[1], :description => ext[2]})
          end
        end
      end

      puts "   - Language"
      exts = ExternalMasterDatabase::ExternalLanguage.all.map{|i| [i.name, i.locale, i.uuid, i.record_status_id, i.custom_value] }
      locals = Language.all
      exts.each do |ext|
        locals.each do |loc|
          if ext[2] == loc.uuid
            loc.update_attributes({:name => ext[0], :locale => ext[1]})
          end
        end
      end

      puts "   - Currencies"
      exts = ExternalMasterDatabase::ExternalAdminSetting.all.map{|i| [i.key, i.value, i.uuid, i.record_status_id, i.custom_value] }
      locals = AdminSetting.all
      exts.each do |ext|
        locals.each do |loc|
          if ext[2] == loc.uuid
            loc.update_attributes({:key => ext[0], :value => ext[1]})
          end
        end
      end

      puts "   - Auth Method"
      exts = ExternalMasterDatabase::ExternalAuthMethod.all.map{|i| [i.name, i.server_name, i.port, i.base_dn, i.certificate, i.uuid, i.record_status_id, i.custom_value] }
      locals = AuthMethod.all
      exts.each do |ext|
        locals.each do |loc|
          if ext[5] == loc.uuid
            loc.update_attributes({:name => ext[0], :server_name => ext[1], :port => ext[2], :base_dn => ext[3], :certificate => ext[4]})
          end
        end
      end

      puts "   - Default groups"
      #Update default groups
      exts = ExternalMasterDatabase::ExternalGroup.all.map{|i| [i.name, i.description, i.uuid, i.record_status_id, i.custom_value] }
      locals = Group.all
      exts.each do |ext|
        locals.each do |loc|
          if ext[2] == loc.uuid
            loc.update_attributes({:name => ext[0], :description => ext[1]})
          end
        end
      end

      puts "   - Labor categories"
      exts = ExternalMasterDatabase::ExternalLaborCategory.all.map{|i| [i.name, i.description, i.uuid, i.record_status_id, i.custom_value] }
      locals = LaborCategory.all
      exts.each do |ext|
        locals.each do |loc|
          if ext[2] == loc.uuid
            loc.update_attributes({:name => ext[0], :description => ext[1]})
          end
        end
      end

      puts "   - Activity categories"
      #Default actitity category
      exts = ExternalMasterDatabase::ExternalActivityCategory.all.map{|i| [i.name, i.alias, i.description, i.uuid, i.record_status_id, i.custom_value] }
      locals = ActivityCategory.all
      exts.each do |ext|
        locals.each do |loc|
          if ext[3] == loc.uuid
            loc.update_attributes({:name => ext[0], :description => ext[1]})
          end
        end
      end

      puts "   - Update project security level"
      locals = ProjectSecurityLevel.all
      exts =  ExternalMasterDatabase::ExternalProjectSecurityLevel.all.map{|i| [i.name, i.uuid]}
      exts.each do |ext|
        locals.each do |loc|
          if ext[1] == loc.uuid
            loc.update_attributes({:name => ext[0]})
          end
        end
      end

      puts "   - Update global permissions"
      locals = Permission.all
      exts = ExternalMasterDatabase::ExternalPermission.all.map{|i| [i.name, i.description, i.is_permission_project, i.uuid, i.record_status_id, i.custom_value] }
      exts.each do |ext|
        locals.each do |loc|
          if ext[3] == loc.uuid
            loc.update_attributes({:name => ext[0], :description => ext[1], :is_permission_project => ext[2]})
          end
        end
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