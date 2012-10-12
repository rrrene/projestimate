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

class ProjectSecurityLevelsController < ApplicationController
  # GET /project_security_levels
  # GET /project_security_levels.json
  def index
    @project_security_levels = ProjectSecurityLevel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_security_levels }
    end
  end

  # GET /project_security_levels/new
  # GET /project_security_levels/new.json
  def new
    @project_security_level = ProjectSecurityLevel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project_security_level }
    end
  end

  # GET /project_security_levels/1/edit
  def edit
    @project_security_level = ProjectSecurityLevel.find(params[:id])
  end

  # POST /project_security_levels
  # POST /project_security_levels.json
  def create
    @project_security_level = ProjectSecurityLevel.new(params[:project_security_level])

    respond_to do |format|
      if @project_security_level.save
        format.html { redirect_to @project_security_level, notice: 'Project security level was successfully created.' }
        format.json { render json: @project_security_level, status: :created, location: @project_security_level }
      else
        format.html { render action: "new" }
        format.json { render json: @project_security_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /project_security_levels/1
  # PUT /project_security_levels/1.json
  def update
    @project_security_level = ProjectSecurityLevel.find(params[:id])

    respond_to do |format|
      if @project_security_level.update_attributes(params[:project_security_level])
        format.html { redirect_to @project_security_level, notice: 'Project security level was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_security_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_security_levels/1
  # DELETE /project_security_levels/1.json
  def destroy
    @project_security_level = ProjectSecurityLevel.find(params[:id])
    @project_security_level.destroy

    respond_to do |format|
      format.html { redirect_to project_security_levels_url }
      format.json { head :ok }
    end
  end
end
