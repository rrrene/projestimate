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
      @user = User.new :auth_type => AuthMethod.first,
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
    @user = User.new( :auth_type => AuthMethod.first,
                      :user_status => "active")
  end

  def create
    set_page_title "New user"

    @user = User.new(params[:user])
    @user.group_ids = Group.find_by_name("Everyone").id

    #Checking password length
    user_pass_length = params[:user][:password].length
    if user_pass_length < good_password_length
      flash[:error] = "password is too short (minimum is #{good_password_length} characters)"
      render "new" and return
    else
      if @user.save
        redirect_to redirect(users_path), :notice => "La mise a jour a été effectué avec succès." and return
      else
        render "new"
      end
    end
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
    user_pass_length = params[:user][:password].length
    if !params[:user][:password].blank?
      if user_pass_length < good_password_length
        flash[:error] = "password is too short (minimum is #{good_password_length} characters)"
        render(:edit) and return
      end
    end

    if @user.update_attributes(params[:user])
      redirect_to(redirect(users_path)) and return
    else
      render(:edit) and return
    end

  end

  #Check password minimum length value
  def good_password_length
    begin
      password_length = default_password_length = 4
      user_as =  AdminSetting.find_by_key("password_min_length")
      if !user_as.nil?
        password_length = user_as.value.to_i
      end
      password_length
    rescue
      password_length
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

      session[:component_id] = nil

      @user = current_user
      @project = current_project
      @pemodules ||= Pemodule.all

      if @project
        @array_module_positions = ModuleProject.where(:project_id => @project.id).sort_by{|i| i.position_y}.map(&:position_y).uniq.max || 1
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

  #Show help
  def show_help
    set_page_title "Help"
    @faq = Help.find_by_help_type_id(HelpType.find_by_name("faq"))
  end

  def library
    authorize! :access_to_admin, User
    set_page_title "Library"
  end

  #Display administration page
  def admin
    authorize! :access_to_admin, User
    set_page_title "Administration"
  end

  def master
    authorize! :access_to_admin, User
    set_page_title "Master parameters"
  end

  #Display parameters page
  def parameters
    set_page_title "Global Parameters"
  end

  def projestimate_globals_parameters
    set_page_title "Projestimate Global Parameters"
  end

  #Apply filter on users index
  def apply_filter
    fields = params[:filter].flatten(2).reject{|i| i == "" }
    @users = User.select(fields)
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
  end

  def activate
    @user = User.find(params[:id])
    unless @user.active?
      @user.user_status = "active"
      @user.save(:validate => false)
    end
    redirect_to users_path
  end

  def user_record_number
    @users = User.page(params[:page]).per_page(params[:nb].to_i || 1)
  end

  def display_states
    unless params[:state] == ""
      @users = User.where(:user_status => params[:state]).page(params[:page])
    else
      @users = User.page(params[:page])
    end
  end

  private

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "first_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
