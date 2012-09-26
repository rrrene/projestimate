class OrganizationsController < ApplicationController
  # GET /organizations/1
  # GET /organizations/1.json
  def show
    authorize! :manage_organizations, Organization
    @organization = Organization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /organizations/new
  # GET /organizations/new.json
  def new
    authorize! :manage_organizations, Organization
    @organization = Organization.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /organizations/1/edit
  def edit
    authorize! :manage_organizations, Organization
    @organization = Organization.find(params[:id])
  end

  # POST /organizations
  # POST /organizations.json
  def create
    authorize! :manage_organizations, Organization
    @organization = Organization.new(params[:organization])

    respond_to do |format|
      if @organization.save
        format.html { redirect_to "/organizationals_params", notice: 'Organization was successfully created.' }
        format.json { render json: @organization, status: :created, location: @organization }
      else
        format.html { render action: "new" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    authorize! :manage_organizations, Organization
    @organization = Organization.find(params[:id])

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html { redirect_to "/organizationals_params", notice: 'Organization was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    authorize! :manage_organizations, Organization
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.json { head :ok }
    end
  end

  #def organizational_params
  #  authorize! :manage_organizations, Organization
  #  set_page_title "Organizational Parameters"
  #  @organizations = Organization.all || []
  #  @organizations_labor_categories = OrganizationLaborCategory.all || []
  #end

end
