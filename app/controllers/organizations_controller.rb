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

class OrganizationsController < ApplicationController
  load_and_authorize_resource

  def new
    authorize! :edit_organizations, Organization

    set_page_title 'Organizations'
    @organization = Organization.new
  end

  def edit
    authorize! :edit_organizations, Organization

    set_page_title 'Organizations'
    @organization = Organization.find(params[:id])

    @attributes = PeAttribute.defined.all
    @attribute_settings = AttributeOrganization.all(:conditions => {:organization_id => @organization.id})

    @complexities = OrganizationUowComplexity.all
    begin
      @ot = @organization.organization_technologies.first
      @unitofworks = @ot.unit_of_works
    rescue
      @ot = nil
      @unitofworks = nil
    end
    @default_subcontractors = @organization.subcontractors.where("alias IN (?)", %w(undefined internal subcontracted))
  end

  def create
    @organization = Organization.new(params[:organization])

    if @organization.save
      #Create the organization's default subcontractor
      subcontractors = [
          ["Undefined", "undefined", "Haven't a clue if it will be subcontracted or made internally"],
          ["Internal", "internal", "Will be made internally"],
          ["Subcontracted", "subcontracted", "Will be subcontracted (but don't know the subcontractor yet)"]
      ]
      subcontractors.each do |i|
        @organization.subcontractors.create(:name => i[0], :alias => i[1], :description => i[2])
      end

      redirect_to redirect_apply(edit_organization_path(@organization)), notice: "#{I18n.t (:notice_organization_successful_created)}"
    else
      render action: 'new'
    end
  end

  def update
    authorize! :edit_organizations, Organization

    @organization = Organization.find(params[:id])
    if @organization.update_attributes(params[:organization])
      flash[:notice] = I18n.t (:notice_organization_successful_updated)
      redirect_to redirect_apply(edit_organization_path(@organization), nil,'/organizationals_params' )
    else
      @attributes = PeAttribute.defined.all
      @attribute_settings = AttributeOrganization.all(:conditions => {:organization_id => @organization.id})

      @complexities = OrganizationUowComplexity.all
      @unitofworks = UnitOfWork.all
      @default_subcontractors = @organization.subcontractors.where("alias IN (?)", %w(undefined internal subcontracted))

      render action: 'edit'
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy
    flash[:notice] = I18n.t (:notice_organization_successful_deleted)
    redirect_to '/organizationals_params'
  end

  def organizationals_params
    set_page_title 'Organizational Parameters'
    @organizations = Organization.all
    @organizations_labor_categories = OrganizationLaborCategory.all || []
  end

  def set_abacus
    authorize! :manage_organizations, Organization

    @ot = OrganizationTechnology.find(params[:technology])
    @complexities = @ot.organization.organization_uow_complexities
    @unitofworks = @ot.unit_of_works

    @unitofworks.each do |uow|
      @complexities.each do |c|
        a = AbacusOrganization.find_or_create_by_unit_or_work_id_and_organization_uow_complexity_id_and_organization_technology_id_and_organization_id(uow.id, c.id, @ot.id, params[:id])
        begin
          a.update_attribute(:value, params["abacus"]["#{uow.id}"]["#{c.id}"])
        rescue
           # :()
        end
      end
    end

    redirect_to edit_organization_path(@ot.organization_id)
  end
end
