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

class AdminSettingsController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

  def index
    set_page_title "Parameters"
    @admin_settings = AdminSetting.all
  end

  def new
    set_page_title "Parameters"
    @admin_setting = AdminSetting.new
  end

  def edit
    set_page_title "Parameters"
    @admin_setting = AdminSetting.find(params[:id])
  end

  def create
    @admin_setting = AdminSetting.new(params[:admin_setting])
    if @admin_setting.save
      flash[:notice] = 'Admin setting was successfully created.'
      redirect_to redirect(admin_settings_path)
    else
      redirect_to new_admin_setting_path
    end
  end

  def update
    @admin_setting = nil
    current_admin_setting = AdminSetting.find(params[:id])
    if current_admin_setting.is_defined?
      @admin_setting = current_admin_setting.dup
    else
      @admin_setting = current_admin_setting
    end

    if params[:admin_setting][:key] == "custom_status_to_consider"
      @admin_setting.update_attribute(:value, params[:admin_setting][:value])
      @admin_setting.update_attribute(:updated_at, params[:admin_setting][:updated_at])
      redirect_to redirect(admin_settings_path)
    else
      if @admin_setting.update_attributes(params[:admin_setting])
        flash[:notice] = 'Admin setting was successfully updated.'
        redirect_to redirect(admin_settings_path)
      else
        redirect_to edit_admin_setting_path(@admin_setting)
      end
    end
  end

  def destroy
    @admin_setting = AdminSetting.find(params[:id])
    if @admin_setting.is_defined?
      #logical deletion: delete don't have to suppress records anymore on defined record
      @admin_setting.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
    else
      @admin_setting.destroy
    end

    flash[:notice] = 'Admin setting was successfully deleted.'
    redirect_to admin_settings_path
  end
end
