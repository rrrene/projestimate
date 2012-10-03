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
      prj_scrt = ProjectSecurity.find_by_user_id(user.id)
      unless prj_scrt.nil?
        specific_permissions_array = prj_scrt.project_security_level.permissions.map{|i| [i.name, i.object_associated.constantize] }
        for perm in specific_permissions_array
          can perm[0].to_sym, perm[1]
        end
      end

      user.group_for_project_securities.each do |grp|
        prj_scrt = ProjectSecurity.find_by_group_id(grp.id)
        unless prj_scrt.nil?
          specific_permissions_array = prj_scrt.project_security_level.permissions.map{|i| [i.name, i.object_associated.constantize] }
          for perm in specific_permissions_array
            can perm[0].to_sym, perm[1]
          end
        end
      end
    end
  end
end



