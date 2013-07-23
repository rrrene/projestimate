#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012-2013 Spirula (http://www.spirula.fr)
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

class ProjectSecuritiesController < ApplicationController

  def index
    authorize! :manage_project_securities, ProjectSecurity
    set_page_title 'Projects Securities'
    @project_security_levels = ProjectSecurityLevel.all
    @permissions = @permissions = Permission.all.select{|i| i.is_permission_project }
  end

  def new
    authorize! :manage_project_securities, ProjectSecurity
    set_page_title 'Project securities'
    @project_security = ProjectSecurity.new
    @projects = Project.all.map{|i| [i.title, i.id]}
    @users = []
  end

  def edit
    authorize! :manage_project_securities, ProjectSecurity
    set_page_title 'Project securities'
    @project_security = ProjectSecurity.find(params[:id])
    @projects = Project.all.map{|i| [i.title, i.id]}
    @users = Project.find(@project_security.project.id).users.map{|i| [i.name, i.id]}
  end

  def create
    authorize! :manage_project_securities, ProjectSecurity
    @project_security = ProjectSecurity.new(params[:project_security])

    if @project_security.save
      @project_security.update_attribute('project_security_level', params[:project_security_level])
      redirect_to redirect_save(project_securities_url), notice: "#{I18n.t (:notice_project_securities_successful_created)}"
    else
      render action: 'new'
    end
  end

  def update
    authorize! :manage_project_securities, ProjectSecurity
    @project_security = ProjectSecurity.find(params[:id])

    respond_to do |format|
      if @project_security.update_attributes(params[:project_security])
        @project_security.update_attribute('project_security_level', params[:project_security_level])
        format.html { redirect_to project_securities_url, notice: "#{I18n.t (:notice_project_securities_successful_updated)}" }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    authorize! :manage_project_securities, ProjectSecurity
    @project_security = ProjectSecurity.find(params[:id])
    @project_security.destroy

    redirect_to redirect_save(project_securities_url)
  end

  #Selected users depending of selected project
  def select_users
    @users = Project.find(params[:project_selected]).users.map{|i| [i.name, i.id]}
  end
end
