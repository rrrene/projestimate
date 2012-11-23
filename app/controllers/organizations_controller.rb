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

class OrganizationsController < ApplicationController

  def new
    authorize! :manage_organizations, Organization
    set_page_title "Organizations"
    @organization = Organization.new

    respond_to do |format|
      format.html # _new.html.erb
    end
  end

  def edit
    set_page_title "Organizations"
    authorize! :manage_organizations, Organization
    @organization = Organization.find(params[:id])
  end

  def create
    authorize! :manage_organizations, Organization
    @organization = Organization.new(params[:organization])

    if @organization.save
      redirect_to redirect("/organizationals_params"), notice: 'Organization was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    authorize! :manage_organizations, Organization
    @organization = Organization.find(params[:id])
    if @organization.update_attributes(params[:organization])
      flash[:notice] = 'Organization was successfully updated.'
      redirect_to redirect("/organizationals_params")
    else
      render action: "edit"
    end
  end

  def destroy
    authorize! :manage_organizations, Organization
    @organization = Organization.find(params[:id])
    @organization.destroy
    flash[:notice] = 'Organization was successfully deleted.'
    redirect_to "/organizationals_params"
  end

  def organizationals_params
    set_page_title "Organizational Parameters"
    @organizations = Organization.all
    @organizations_labor_categories = OrganizationLaborCategory.all || []
  end

end
