class AdminSettingsController < ApplicationController

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
    flash[:notice] = 'Admin setting was successfully created.'
    redirect_to admin_settings_path
  end

  def update
    @admin_setting = AdminSetting.find(params[:id])
    flash[:notice] = 'Admin setting was successfully updated.'
    redirect_to admin_settings_path
  end

  def destroy
    @admin_setting = AdminSetting.find(params[:id])
    @admin_setting.destroy
    flash[:notice] = 'Admin setting was successfully deleted.'
    redirect_to admin_settings_path
  end
end
