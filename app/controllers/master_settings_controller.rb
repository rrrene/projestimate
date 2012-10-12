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

class MasterSettingsController < ApplicationController
  # GET /master_settings
  # GET /master_settings.json
  def index
    set_page_title "Projestimate Global Parameters"
    @master_settings = MasterSetting.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @master_settings }
    end
  end

  # GET /master_settings/new
  # GET /master_settings/new.json
  def new
    set_page_title "Projestimate Global Parameters"
    @master_setting = MasterSetting.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @master_setting }
    end
  end

  # GET /master_settings/1/edit
  def edit
    set_page_title "Projestimate Global Parameters"
    @master_setting = MasterSetting.find(params[:id])
  end

  # POST /master_settings
  # POST /master_settings.json
  def create
    @master_setting = MasterSetting.new(params[:master_setting])

    respond_to do |format|
      if @master_setting.save
        format.html { redirect_to master_settings_path, notice: 'Master setting was successfully created.' }
        format.json { render json: @master_setting, status: :created, location: @master_setting }
      else
        format.html { render action: "new" }
        format.json { render json: @master_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /master_settings/1
  # PUT /master_settings/1.json
  def update
    @master_setting = MasterSetting.find(params[:id])

    respond_to do |format|
      if @master_setting.update_attributes(params[:master_setting])
        format.html { redirect_to master_settings_path, notice: 'Master setting was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @master_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_settings/1
  # DELETE /master_settings/1.json
  def destroy
    @master_setting = MasterSetting.find(params[:id])
    @master_setting.destroy

    respond_to do |format|
      format.html { redirect_to master_settings_url }
      format.json { head :ok }
    end
  end
end
