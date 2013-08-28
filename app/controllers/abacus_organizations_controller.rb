class AbacusOrganizationsController < ApplicationController
  # GET /abacus_organizations
  # GET /abacus_organizations.json
  def index
    @abacus_organizations = AbacusOrganization.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @abacus_organizations }
    end
  end

  # GET /abacus_organizations/1
  # GET /abacus_organizations/1.json
  def show
    @abacus_organization = AbacusOrganization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @abacus_organization }
    end
  end

  # GET /abacus_organizations/new
  # GET /abacus_organizations/new.json
  def new
    @abacus_organization = AbacusOrganization.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @abacus_organization }
    end
  end

  # GET /abacus_organizations/1/edit
  def edit
    @abacus_organization = AbacusOrganization.find(params[:id])
  end

  # POST /abacus_organizations
  # POST /abacus_organizations.json
  def create
    @abacus_organization = AbacusOrganization.new(params[:abacus_organization])

    respond_to do |format|
      if @abacus_organization.save
        format.html { redirect_to @abacus_organization, notice: 'Abacus organization was successfully created.' }
        format.json { render json: @abacus_organization, status: :created, location: @abacus_organization }
      else
        format.html { render action: "new" }
        format.json { render json: @abacus_organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /abacus_organizations/1
  # PUT /abacus_organizations/1.json
  def update
    @abacus_organization = AbacusOrganization.find(params[:id])

    respond_to do |format|
      if @abacus_organization.update_attributes(params[:abacus_organization])
        format.html { redirect_to @abacus_organization, notice: 'Abacus organization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @abacus_organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /abacus_organizations/1
  # DELETE /abacus_organizations/1.json
  def destroy
    @abacus_organization = AbacusOrganization.find(params[:id])
    @abacus_organization.destroy

    respond_to do |format|
      format.html { redirect_to abacus_organizations_url }
      format.json { head :no_content }
    end
  end
end
