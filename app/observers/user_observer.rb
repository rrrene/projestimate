class UserObserver < ActiveRecord::Observer
  observe User

  def after_update(user)
    if user.user_status_changed?
      if user.suspended? || user.pending? || user.blacklisted?
        UserMailer.account_suspended(user).deliver
      else
        if user.password.blank?
          if user.type_auth == "app"
            user.password = Standards.random_string(8)
            user.save
            UserMailer.account_validate(user).deliver
          else
            UserMailer.account_validate_ldap(user).deliver
          end
        else
          UserMailer.account_validate_no_pw(user).deliver
        end
      end
    end
  end

end