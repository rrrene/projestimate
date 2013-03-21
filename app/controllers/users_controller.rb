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

class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :verify_authentication, :except => [:show, :create_inactive_user, ]

  before_filter :load_data, :only => [:update, :edit, :new, :create]

  def load_data
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = User.new :auth_type => AuthMethod.first.id,
                       :user_status => "active"
    end
    @projects = Project.all
    @organizations = Organization.all
    @groups = Group.all
    @project_users = @user.projects
    @org_users = @user.organizations
    @project_groups = @user.groups
  end

  def index
    authorize! :edit_user_account_no_admin, User
    set_page_title "Users"
    @users = User.page(params[:page]).per_page(5).where(:user_status => "active")


    respond_to do |format|
      format.html
      format.js {
        render "user_record_number.js"
      }
    end
  end
  
  def new
    authorize! :edit_user_account_no_admin, User
    set_page_title "New user"
    @user = User.new( :auth_type => AuthMethod.first.id,
                      :user_status => "active")
  end

  def create
    set_page_title "New user"

    @user = User.new(params[:user])
    @user.group_ids = Group.find_by_name("Everyone").id

    #Checking password length
    user_pass_length = params[:user][:password].length
    #if user_pass_length < good_password_length
    #  flash[:password_error] = "password is too short (minimum is #{good_password_length} characters)"
    #  render "new" and return
    #else
      if @user.save
        redirect_to redirect(users_path), :notice => "The account was successfully created"
      else
        render "new"
      end

    #end
  end

  def edit
    set_page_title "Edit user"
    @user = User.find(params[:id])
  end


  #Update user
  def update
    set_page_title "Edit user"

    params[:user][:group_ids] ||= []
    @user = User.find(params[:id])

    #Checking password length
    #user_pass_length = params[:user][:password].length
    #if !params[:user][:password].blank?
    #  if user_pass_length < good_password_length
    #    flash[:password_error] = "password is too short (minimum is #{good_password_length} characters)"
    #    render(:edit) and return
    #  end
    #end

    if @user.update_attributes(params[:user])
      redirect_to(redirect(users_path), :notice => "The account was successfully updated." )
    else
      render(:edit)
    end

  end

  #Dashboard of the application
  def show
    set_page_title "Dashboard"

      if current_user
        if params[:project_id]
          session[:current_project_id] = params[:project_id]

          # tlp : ten latest projects
          tlp = User.first.ten_latest_projects || Array.new
          tlp = tlp.push(params[:project_id])
          User.first.update_attribute(:ten_latest_projects, tlp.uniq)
        end

      session[:pbs_project_element_id] = nil

      @user = current_user
      @project = current_project
      @pemodules ||= Pemodule.all
      if @project
        @module_projects ||= @project.module_projects
      end
      @pe_wbs_project_activity = @project.pe_wbs_projects.wbs_activity.first unless @project.nil?
      @show_hidden = "true"

      if @project
        @module_positions = ModuleProject.where(:project_id => @project.id).sort_by{|i| i.position_y}.map(&:position_y).uniq.max || 1
      end
    else
      render :layout => "login"
    end
  end

  #Create a inactive user if the demand is ok.
  def create_inactive_user
    unless (params[:email].blank? || params[:first_name].blank? || params[:last_name].blank? || params[:login_name].blank?)
      user = User.first(:conditions => ["login_name = '#{params[:login_name]}' or email = '#{params[:email]}'"])
      if !user.nil?
        redirect_to root_url, :notice => "  Email or user name already exist in the database."
      else
        user = User.new(:email => params[:email],
                         :first_name => params[:first_name],
                         :last_name => params[:last_name],
                         :login_name => params[:login_name],
                         :language_id => params[:language],
                         :initials => "your_initials",
                         :user_status => "pending",
                         :auth_method => AuthMethod.find_by_name("Application"))

        user.password = Standards.random_string(8)
        user.group_ids = [Group.last.id]
        user.save(:validate => false)

        UserMailer.account_created(user).deliver
        UserMailer.account_request.deliver
        redirect_to root_url, :notice => "Account demand send with success."
      end
    else
      redirect_to root_url, :notice => "Please check all fields."
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path
  end

  def find_use_user
    @user = User.find(params[:user_id])

    respond_to do |format|
      format.js { render :partial => "users/find_use.js" }
    end
  end

  def about
    set_page_title "About"
    latest_record_version = Version.last
    @latest_repo_update = latest_record_version.repository_latest_update #Home::latest_repo_update
    @latest_local_update =  latest_record_version.local_latest_update
    Rails.cache.write("latest_update", @latest_local_update)
  end

  def activate
    @user = User.find(params[:id])
    unless @user.active?
      @user.user_status = "active"
      @user.save(:validate => false)
    end
    redirect_to users_path
  end

  def display_states
    unless params[:state] == ""
      @users = User.where(:user_status => params[:state]).page(params[:page])
    else
      @users = User.page(params[:page])
    end
  end

end
