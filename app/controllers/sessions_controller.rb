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

class SessionsController < ApplicationController

  def new
  end

  #Create a session for user if user is authorized
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      if user.active?

        #TODO: #Use AASM for user status
        if params[:remember_me]
          cookies[:login] = { :value => user.user_name, :expires => Time.now + 3600}
        end

        #Last and previous login setting
        user.update_attribute("previous_login", user.last_login)
        user.update_attribute("last_login", Time.now)

        #Set current user
        session[:current_user_id] = user.id

        #Set current project
        if user.projects.empty?
          session[:current_project_id] = nil
        else
          session[:current_project_id] = user.projects.first.id
        end

        redirect_to session[:remember_address] || "/dashboard", :flash => { :notice => "Welcome #{user.name}" }
      elsif user.suspended? || user.blacklisted?
        redirect_to "/dashboard", :flash => { :error => "Your account is black-listed" }
      else

      end
    else
        redirect_to "/dashboard", :flash => { :error => "Invalid user name or password" }
    end
  end

  #Logout
  def destroy
    session[:current_user_id] = nil
    redirect_to root_url
  end

  #Login
  def login
    render :layout => 'login'
  end

  #Display new account page
  def ask_new_account
    @user = User.new
  end

  #Display help login page
  def help_login
  end


end
