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
    mail(:to => Ad, :subject => "Demande de création de compte")
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
