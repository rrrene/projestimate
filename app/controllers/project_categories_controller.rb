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

class ProjectCategoriesController < ApplicationController

  def new
    set_page_title "Project Category"
    @project_category = ProjectCategory.new
  end

  def edit
    set_page_title "Project Category"
    @project_category = ProjectCategory.find(params[:id])
  end

  def create
    @project_category = ProjectCategory.new(params[:project_category])

    if @project_category.save
      flash[:notice] = "Project category was successfully created."
      redirect_to "/projects_global_params#tabs-2"
    else
      render action: "new"
    end
  end

  def update
    @project_category = ProjectCategory.find(params[:id])

    if @project_category.update_attributes(params[:project_category])
      flash[:notice] = "Project category was successfully updated."
      redirect_to "/projects_global_params#tabs-2"
    else
      render action: "edit"
    end
  end

  def destroy
    @project_category = ProjectCategory.find(params[:id])
    @project_category.destroy

    flash[:notice] = "Project category was successfully deleted."
    redirect_to "/projects_global_params#tabs-2"
  end
end
