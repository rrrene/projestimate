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

#encoding: utf-8
#TODO:rename this controller to something most eloquent/verbose/meaningful
class PasswordResetsController < ApplicationController
  layout "login"

  #Display "forgotten password" page
  def new
  end

  #Reset the password depending of the status of the user
  def create
    user = User.first(:conditions => ['user_name = ? or email = ?', params[:user_name], params[:user_name] ])
    if user
      if user.type_auth == "app"
        if user.active?
          user.send_password_reset if user
          redirect_to root_url, :notice => "Password reset instructions have been sent."
        else
          user.send_password_reset if user
          redirect_to root_url, :notice => "Your account is not active"
        end
      else
        redirect_to root_url, :notice => "Your account is associated with the corporate directory. Please contact your system administrator."
      end
    else
      redirect_to root_url, :notice => "Bad user name"
    end
  end

  #Edit the new password
  #checks token validity
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  #Update the new password
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      UserMailer.new_password(@user).deliver
      redirect_to new_password_reset_path, :alert => "Reset processus expired."
    elsif @user.update_attributes(params[:user])
      UserMailer.new_password(@user).deliver
      redirect_to root_url, :notice => "Your password has been reset successfully. A confirmation email have been sent."
    else
      render :edit
    end
  end

  #def forgotten_password
  #  @user = User.find_by_email(params[:email])
  #  UserMailer.forgotten_password(@user).deliver
  #end

end

