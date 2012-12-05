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

#Ability for role management. See CanCan on github fore more informations about Role.
class Ability
  include CanCan::Ability

  #Initialize Ability then load permissions
  def initialize(user)
#    Uncomment in order to authorize everybody to manage all the app
    can :manage, :all

    #Load user groups permissions
    if user && !user.groups.empty?
      permissions_array = []
      #Filtrer sur les groups for global permissions
      user.group_for_global_permissions.map{|grp| grp.permissions.map{|i| permissions_array << [i.name, i.object_associated.constantize]}}
      for perm in permissions_array
        can perm[0].to_sym, perm[1]
      end

      #Specfic project security loading
      #prj_scrt = ProjectSecurity.find_by_user_id(user.id)
      #unless prj_scrt.nil?
      #  specific_permissions_array = prj_scrt.project_security_level.permissions.map{|i| [i.name, i.object_associated.constantize] }
      #  for perm in specific_permissions_array
      #    can perm[0].to_sym, perm[1]
      #  end
      #end
      #

      #user.group_for_project_securities.each do |grp|
      #  prj_scrt = ProjectSecurity.find_by_group_id(grp.id)
      #  unless prj_scrt.nil?
      #    specific_permissions_array = prj_scrt.project_security_level.permissions.map{|i| [i.name, i.object_associated.constantize] }
      #    for perm in specific_permissions_array
      #      can perm[0].to_sym, perm[1]
      #    end
      #  end
      #end

      can :manage_attributes, Attribute

    end
  end
end



