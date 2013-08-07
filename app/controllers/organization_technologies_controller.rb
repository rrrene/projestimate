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
    if @organization_technology.save
      flash[:notice] = I18n.t (:notice_organization_technology_successful_created)
      redirect_to redirect_apply(nil, new_organization_technology_path(params[:organization_technology]),edit_organization_path(params[:organization_technology][:organization_id], :anchor=>'tabs-4'))
    else
      render action: 'new'
      end
  end

  def update
    authorize! :create_edit_organizations, Organization

    @organization_technology = OrganizationTechnology.find(params[:id])
    if @organization_technology.update_attributes(params[:organization_technology])
      flash[:notice] = I18n.t (:notice_organization_technology_successful_updated)
      redirect_to redirect_apply(edit_organization_technology_path(params[:organization_technology]),nil,edit_organization_path(params[:organization_technology][:organization_id], :anchor=>'tabs-4'))
    else
      render action: 'edit'
    end
  end

  def destroy
    @organization_technology = OrganizationTechnology.find(params[:id])
    organization_id = @organization_technology.organization_id
    @organization_technology.delete
    respond_to do |format|
      format.html { redirect_to redirect(edit_organization_path(organization_id, :anchor=>'tabs-4')), notice: "#{I18n.t (:notice_organization_technology_successful_deleted)}"}
    end
  end
end
