class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :current_project
  helper_method :current_component
  helper_method :load_master_setting
  helper_method :load_admin_setting

  before_filter :set_user_time_zone
  before_filter :set_user_language
  before_filter :set_return_to
  before_filter :previous_page

  def verify_authentication
    if session[:current_user_id].nil?
      session[:remember_address] = self.request.fullpath
      redirect_to root_url
    end
  end

  def redirect(url)
    (params[:save].nil?) ? url : session[:return_to]
  end

  def set_return_to
    session[:return_to] = request.referer
  end

  def previous_page
    session[:now] ||= ""

    session[:previous] = session[:now]
    session[:now] = request.referer
  end

  def current_user
    begin
     (User.find(session[:current_user_id]) if session[:current_user_id]) || (User.find_by_email(cookies[:login]) if cookies[:login] || nil)
    rescue ActiveRecord::RecordNotFound
      reset_session
    end
  end

  def current_project
    prj = Project.find_by_id(session[:current_project_id])
    if prj.nil?
      if current_user.nil?
        return nil
      else
        current_user.projects.first
      end
    else
      return prj
    end
  end

  def current_component
    session[:component_id].nil? ? current_project.root_component : Component.find(session[:component_id])
  end

  def load_master_setting(args)
    ms = MasterSetting.find_by_key(args)
    unless ms.nil?
      MasterSetting.find_by_key(args).value
    end
  end

  def load_admin_setting(args)
    as = AdminSetting.find_by_key(args)
    unless as.nil?
      AdminSetting.find_by_key(args).value
    end
  end

  def set_user_language
    unless current_user.nil?
      session[:current_locale] = current_user.language.locale.downcase
    else
      session[:current_locale] = "en"
    end
    @current_locale = session[:current_locale]
    I18n.locale = session[:current_locale]
  end
  
  def set_user_time_zone
    if current_user
      unless current_user.time_zone.blank?
        Time.zone = current_user.time_zone
      end
    end
  end

  def set_page_title(page_title)
    @page_title = page_title
  end

  def current_url(page_title)
    @page_title = page_title
  end

  #Rescue method
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied!"
    redirect_to root_url
  end

  rescue_from ActionController::RoutingError do |exception|
    flash[:error] = "Error 404 Not Found"
    redirect_to root_url
  end

  if Rails.env == "production"
    rescue_from Exception do |exception|
      flash[:error] = "Something went wrong :  #{exception.message}"
    end
  end

  end
