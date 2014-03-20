# -*- coding: utf-8 -*-
class Audit < ActiveRecord::Base
  # attr_accessible :title, :body

  serialize :audited_changes, Hash

  def customize_action_name
    audit_action = ""
    if self.action
      case self.action
        when "create"
          audit_action = "Création"
        when "update"
          audit_action = "Modification"
        when "delete"
          audit_action = "Suppression"
      end
    end
    return audit_action
  end

  # customize the changes
  def customize_audited_changes
    changes = ""
    if self.action && self.audited_changes
      case self.action
        when "create"
          changes = "Création d'un nouvel objet '#{self.auditable_type}' (id = #{self.auditable_id})"
        when "update"
          audited_value = self.audited_changes
          changed_attribute = audited_value[audited_value.keys.first]
          changes = "Modification de la valeur du champ '#{self.audited_changes.keys.first}' de '#{changed_attribute.first}' à '#{changed_attribute.last}' "
        when "delete"
          changes = "Suppression"
      end
    end
    return changes
  end


  def customize_user_id
    user = ""
    if self.user_id
      if user = User.find(self.user_id)
        user = "#{user.login_name}"
      end
    end
    return user
  end
end


