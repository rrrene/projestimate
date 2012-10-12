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

class PermissionsController < ApplicationController

  def index
    set_page_title "Permissions listings"
    @permissions = Permission.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def globals_permissions
    authorize! :manage_permissions, Permission
    set_page_title "Globals Permissions"
    @permissions = Permission.all.select{|i| i.is_permission_project == false }
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def new
    authorize! :manage_permissions, Permission
    set_page_title "Permissions"
    @permission = Permission.new

    respond_to do |format|
      format.html # _new.html.erb
    end
  end

  # GET /permissions/1/edit
  def edit
    authorize! :manage_permissions, Permission
    set_page_title "Permissions"
    @permission = Permission.find(params[:id])
  end

  # POST /permissions
  # POST /permissions.json
  def create
    @permission = Permission.new(params[:permission])

    @groups = Group.all

    respond_to do |format|
      if @permission.save
        format.html { redirect_to permissions_path, notice: 'Function was successfully created.' }
        format.json { render json: @permission, status: :created, location: @permission }
      else
        format.html { render action: "new" }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /permissions/1
  # PUT /permissions/1.json
  def update
    @permission = Permission.find(params[:id])

    respond_to do |format|
      if @permission.update_attributes(params[:permission])

        format.html { redirect_to "/globals_permissions", notice: 'Function was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permissions/1
  # DELETE /permissions/1.json
  def destroy
    @permission = Permission.find(params[:id])
    @permission.destroy

    respond_to do |format|
      format.html { redirect_to permissions_path }
      format.json { head :ok }
    end
  end

  #Set all global rights
  def set_rights
    authorize! :manage_permissions, Permission
    @groups = Group.all
    @permissions = Permission.all

    @groups.each do |group|
      group.update_attribute("permission_ids", params[:permissions][group.id.to_s])
    end

    respond_to do |format|
      format.html { redirect_to "/globals_permissions", :notice => "Permissions saved succesfully" }
    end

  end

  #Set all project security rights
  def set_rights_project_security
    authorize! :manage_specific_permissions, Permission
    @project_security_levels = ProjectSecurityLevel.all
    @permissions = Permission.all

    @project_security_levels.each do |psl|
      psl.update_attribute("permission_ids", params[:permissions][psl.id.to_s])
    end

    respond_to do |format|
      format.html { redirect_to project_securities_path, :notice => "Permissions saved succesfully" }
    end

  end
end
