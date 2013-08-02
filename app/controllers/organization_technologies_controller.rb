class OrganizationTechnologiesController < ApplicationController
  load_and_authorize_resource

  def index
    authorize! :create_edit_organizations, Organization

    @organization = Organization.find(params[:id])
    @organization_technologies = @organization.organization_technologies
  end

  def edit
    authorize! :create_edit_organizations, Organization

    @organization_technology = OrganizationTechnology.find(params[:id])
  end

  def new
    authorize! :create_edit_organizations, Organization

    @organization_technology = OrganizationTechnology.new
  end

  def create
    authorize! :create_edit_organizations, Organization

    @organization_technology = OrganizationTechnology.new(params[:organization_technology])
    @organization_technology.save
    redirect_to edit_organization_path(params[:organization_technology][:organization_id])
  end

  def update
    authorize! :create_edit_organizations, Organization

    @organization_technology = OrganizationTechnology.find(params[:id])
    @organization_technology.update_attributes(params[:organization_technology])
    redirect_to edit_organization_path(@organization_technology.organization_id)
  end

  def destroy
    @organization_technology = OrganizationTechnology.find(params[:id])
    organization_id = @organization_technology.organization_id
    @organization_technology.delete
    redirect_to edit_organization_path(organization_id)
  end
end
