#ProjectSecurity belongs to User, Group and Project
class ProjectSecurity < ActiveRecord::Base
  belongs_to :user
  #belongs_to :group
  belongs_to :project
  belongs_to :project_security_level

  #Make a link between a security level and a alias.
  #def decode_security_level
  #  case self.project_security_level
  #  when 0
  #    "Read only"
  #  when 1
  #    "Comment"
  #  when 2
  #    "Modify"
  #  when 3
  #    "Define"
  #  when 4
  #    "Full control"
  #  end
  #end

  #Make a link between a security level and a symbol value.
  #def project_security_level_cancan
  #  case self.project_security_level.level
  #  when 0
  #    :read_only
  #  when 1
  #    :comment
  #  when 2
  #    :modify
  #  when 3
  #    :define
  #  when 4
  #    :full_control
  #  else
  #    :read_only
  #  end
  #end

  #Return level of security project
  def level
    self.project_security_level.nil? ? '-' : self.project_security_level.name
  end
end
