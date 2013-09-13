class SubcontractorsController < ApplicationController
  load_resource

  def new
    authorize! :edit_organizations, Organization
    @subcontractor = Subcontractor.new
    @organization = Organization.find_by_id(params[:organization_id])
  end

  def edit
    #No authorize required since everyone can edit
    @subcontractor = Subcontractor.find(params[:id])
    @organization = @subcontractor.organization

    @default_subcontractors = @organization.subcontractors.where('alias IN (?)', %w(undefined internal subcontracted))
    if @subcontractor.alias.in?(%w(undefined internal subcontracted))
      flash[:error] = "#{@subcontractor.name} subcontractor can't be modified"
      redirect_to edit_organization_path(@organization, :anchor => 'tabs-7')
    end

  end

  def create
    authorize! :edit_organizations, Organization
    set_page_title 'Subcontractors'
    @subcontractor = Subcontractor.new(params[:subcontractor])
    @organization = Organization.find_by_id(params['subcontractor']['organization_id'])

    if @subcontractor.save
      flash[:notice] = I18n.t(:notice_subcontractor_successfully_created)
      redirect_to edit_organization_path(@organization, :anchor => 'tabs-7')
    else
      render action: 'new', :organization_id => @organization.id
    end
  end

  def update
    authorize! :edit_organizations, Organization
    @subcontractor = Subcontractor.find(params[:id])
    @organization = @subcontractor.organization

    if @subcontractor.update_attributes(params[:subcontractor])
      flash[:notice] = I18n.t(:notice_subcontractor_successfully_updated)
      redirect_to (edit_organization_path(@organization, :anchor => 'tabs-7'))
    else
      render action: 'edit', :organization_id => @organization.id
    end
  end

  def destroy
    authorize! :edit_organizations, Organization
    @subcontractor = Subcontractor.find(params[:id])
    organization_id = @subcontractor.organization_id
    @subcontractor.destroy
    flash[:notice] = I18n.t(:notice_subcontractor_successfully_deleted)
    redirect_to edit_organization_path(organization_id, :anchor => 'tabs-7')
  end
end
