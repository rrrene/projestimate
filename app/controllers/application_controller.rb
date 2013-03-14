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

class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_to root_url
  end

  rescue_from Errno::ECONNREFUSED do |error|
    flash[:error] = "Connection refused - Try to restart SOLR"
  end

  helper_method :is_master_instance?    #Identify if we are on Master or Local instance

  helper_method :current_user
  helper_method :current_project
  helper_method :current_component
  helper_method :load_master_setting
  helper_method :load_admin_setting
  helper_method :get_record_statuses

  before_filter :set_user_time_zone
  before_filter :set_user_language
  before_filter :set_return_to
  before_filter :previous_page

  #For some specific tables, we need to know if record is created on MasterData instance or on the local instance
  #This method test if we are on Master or Local instance
  def is_master_instance?
    defined?(MASTER_DATA) and MASTER_DATA and File.exists?("#{Rails.root}/config/initializers/master_data.rb")
  end

  def verify_authentication
    unless self.request.format == "application/json"
      if session[:current_user_id].nil?
        session[:remember_address] = self.request.fullpath
      end
    else
      session[:remember_address] = "/dashboard"
    end
  end

  def redirect(url)
    begin
      (params[:commit] == "#{I18n.t "save"}"  or params[:commit] == "Save") ? url : session[:return_to]
    rescue
      url
    end
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
    prj = Project.where(:id => session[:current_project_id])
    if prj.nil?
      if current_user.nil?
        return nil
      else
        current_user.projects.first
      end
    else
      return prj.first
    end
  end

  def current_component
    begin
    if current_project
      session[:pbs_project_element_id].blank? ? current_project.root_component : PbsProjectElement.find(session[:pbs_project_element_id])
    end
    rescue
      session[:pbs_project_element_id] = nil
    end
  end

  def current_wbs_project_element
    if current_project
      session[:wbs_project_element_id].nil? ? current_project.wbs_project_element_root : WbsProjectElement.find(session[:wbs_project_element_id])
    end
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

  #Get record statuses
  def get_record_statuses
    @retired_status = RecordStatus.find_by_name("Retired")
    @proposed_status = RecordStatus.find_by_name("Proposed")
    @defined_status = RecordStatus.find_by_name("Defined")
    @custom_status = RecordStatus.find_by_name("Custom")
    @local_status = RecordStatus.find_by_name("Local")
  end


  #Rescue method
  #rescue_from ActionController::RoutingError do |exception|
  #  flash[:error] = "Error 404 Not Found"
  #  redirect_to root_url
  #end

  #if Rails.env == "production"
  #  rescue_from Exception do |exception|
  #    flash[:error] = "Something went wrong :  #{exception.message)
  #  end
  #end



end
