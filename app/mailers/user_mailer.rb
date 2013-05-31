#encoding: utf-8
#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012-2013 Spirula (http://www.spirula.fr)
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
  default :from => 'no-reply@spirula.fr'
  OLD_LOCALE = I18n.locale

  #Send the new password
  def forgotten_password(user)
    @user = user
    I18n.locale = user.locale
    mail(:to => @user.email, :subject => I18n.t(:mail_subject_lost_password))
  ensure
    reset_locale
  end

  #Confirm the new password
  def new_password(user)
    @user = user
    I18n.locale = user.locale
    mail(:to => @user.email, :subject => I18n.t(:mail_subject_new_password))
  ensure
    reset_locale
  end

  #Send an account request
  def account_request
    I18n.locale = 'en'
    mail(:to => AdminSetting.find_by_key('notifications_email').value, :subject => I18n.t(:mail_subject_account_activation_request))
  ensure
    reset_locale
  end

  #Confirm validation of account - password is written
  def account_validate(user)
    @user = user
    I18n.locale = user.locale
    mail(:to => @user.email, :subject => I18n.t(:mail_subject_account_activation))
  ensure
    reset_locale
  end

  #Confirm validation of account - the password is not written
  def account_validate_no_pw(user)
    @user = user
    I18n.locale = user.locale
    mail(:to => @user.email, :subject => I18n.t(:mail_subject_account_activation))
  ensure
    reset_locale
  end

  #Notify than account is suspended
  def account_suspended(user)
    @user = user
    I18n.locale = user.locale
    mail(:to => @user.email, :subject => I18n.t(:mail_subject_account_suspended))
  ensure
    reset_locale
  end

  #Confirm validation of account (ldap protocol)
  def account_validate_ldap(user)
    @user = user
    I18n.locale = user.locale
    mail(:to => @user.email, :subject => I18n.t(:mail_subject_account_activation))
  ensure
    reset_locale
  end

  #Account created
  def account_created(user)
    @user = user
    I18n.locale = user.locale
    mail(:to => @user.email, :subject => I18n.t(:mail_subject_account_created))
  ensure
    reset_locale
  end

  protected
  def reset_locale
    I18n.locale = OLD_LOCALE
  end

end
