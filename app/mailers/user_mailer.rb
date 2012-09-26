#encoding: utf-8
##Mail management for User.
class UserMailer < ActionMailer::Base
  default :from => "no-reply@spirula.fr"

  #Send the new password
  def forgotten_password(user)
    @user = user
    mail(:to => user.email, :subject => "Votre nouveau mot de passe")
  end

  #Confirm the new password
  def new_password(user)
    @user = user
    mail(:to => user.email, :subject => "Confirmation de changements de mots de passe.")
  end

  #Send an account request
  def account_request
    mail(:to => "renard760@gmail.com", :subject => "Demande de création de compte")
  end

  #Confirm validation of account - password is writed
  def account_validate(user)
    @user = user
    mail(:to => @user.email, :subject => "Compte Projestimate validé")
  end

  #Confirm validation of account - the password is not writed
  def account_validate_no_pw(user)
    @user = user
    mail(:to => @user.email, :subject => "Compte Projestimate validé")
  end

  #Notify than account is suspended
  def account_suspended(user)
    @user = user
    mail(:to => @user.email, :subject => "Compte Projestimate validé")
  end

  #Confirm validation of account (ldap protocol)
  def account_validate_ldap(user)
    @user = user
    mail(:to => load_admin_setting("notifications_email"), :subject => "Votre compte Projestimate validé")
  end
  
end
