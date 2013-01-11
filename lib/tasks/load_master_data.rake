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
          RecordStatus.delete_all


          Home::load_master_data!
        end
        i = false
      elsif response == '2'
        puts "Nothing to do. Bye."
        i = false
      end
    end
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