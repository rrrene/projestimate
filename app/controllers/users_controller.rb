#encoding: utf-8
class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :verify_authentication, :except => :show

  def index
    authorize! :edit_user_account_no_admin, User
    set_page_title "Users"

    respond_to do |format|
      format.html
      format.json {
        @users = UsersDatatable.new(view_context)
        render json: @users
      }
    end
  end
  
  def new
    authorize! :edit_user_account_no_admin, User
    set_page_title "New user"

    @user = User.new
    @projects = Project.all
    @groups = Group.all
    @project_users = @user.projects
    @project_groups = @user.groups
    @organizations = Organization.all
    @org_users = @user.organizations
  end

  def create
    authorize! :edit_user_account_no_admin, User

    @user = User.new(params[:user])
    @user.group_ids = Group.find_by_name("Everyone").id

    if @user.save
      redirect_to users_path, :notice => "La mise a jour a été effectué avec succès."
    else
      render "new"
    end
  end

  def edit
    set_page_title "Edit user"
    @user = current_user
    @projects = Project.all
    @organizations = Organization.all
    @groups = Group.all
    @project_users = @user.projects
    @org_users = @user.organizations
    @project_groups = @user.groups
  end

  #Update user
  #If user_status changed, an email is sent
  def update
    params[:user][:group_ids] ||= []
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_path, notice: 'La mise a jour a été effectué avec succès.' }
        format.json { head :ok }
      else
        # TODO: Pas besoin de ce morceau puisque qu'on rapelle edit ?
        #############################################
          @projects = Project.all
          @groups = Group.all
          @project_users = @user.projects
          @project_groups = @user.groups
        #############################################
        format.html { render "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
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

      if @project
        @array_module_positions = ModuleProject.find_all_by_project_id(@project.id).sort_by{|i| i.position_y}.map(&:position_y).uniq.max || 1
      end
    else
      render :layout => "login"
    end
  end

  #Create a inactive user if the demand is ok.
  def create_inactive_user
    unless (params[:email].blank? || params[:first_name].blank? || params[:surename].blank? || params[:user_name].blank?)
      user = User.first(:conditions => ["user_name = '#{params[:user_name]}' or email = '#{params[:email]}'"])
      if user != nil
        redirect_to root_url, :error => "Email or user name already exist in the database."
      else
        user = User.new(:email => params[:email], :first_name => params[:first_name], :surename => params[:surename], :user_name => params[:user_name], :is_super_admin => false, :language_id => params[:language], :group_ids =>[3])
        user.group_ids = [3]
        user.save
        UserMailer.account_request.deliver
        redirect_to root_url, :notice => "Account demand send with success."
      end
    else
      redirect_to root_url, :error => "Please check all fields."
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

    respond_to do |format|
      format.html { redirect_to users_path }
      format.json { head :ok }
    end
  end

  def find_use_user
    @user = User.find(params[:user_id])

    respond_to do |format|
      format.js { render :partial => "users/find_use.js" }
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
