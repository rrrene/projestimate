class OrganizationLaborCategoriesController < ApplicationController
  # GET /organization_labor_categories
  # GET /organization_labor_categories.json
  def index
    @organization_labor_categories = OrganizationLaborCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organization_labor_categories }
    end
  end

  # GET /organization_labor_categories/1
  # GET /organization_labor_categories/1.json
  def show
    @organization_labor_category = OrganizationLaborCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organization_labor_category }
    end
  end

  # GET /organization_labor_categories/new
  # GET /organization_labor_categories/new.json
  def new
    @organization_labor_category = OrganizationLaborCategory.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @organization_labor_category }
    end
  end

  # GET /organization_labor_categories/1/edit
  def edit
    @organization_labor_category = OrganizationLaborCategory.find(params[:id])
  end

  # POST /organization_labor_categories
  # POST /organization_labor_categories.json
  def create
    @organization_labor_category = OrganizationLaborCategory.new(params[:organization_labor_category])

    respond_to do |format|
      if @organization_labor_category.save
        format.html { redirect_to "/organizationals_params", notice: 'Organization labor category was successfully created.' }
        format.json { render json: @organization_labor_category, status: :created, location: @organization_labor_category }
      else
        format.html { render action: "new" }
        format.json { render json: @organization_labor_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /organization_labor_categories/1
  # PUT /organization_labor_categories/1.json
  def update
    @organization_labor_category = OrganizationLaborCategory.find(params[:id])

    respond_to do |format|
      if @organization_labor_category.update_attributes(params[:organization_labor_category])
        format.html { redirect_to "/organizationals_params", notice: 'Organization labor category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization_labor_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_labor_categories/1
  # DELETE /organization_labor_categories/1.json
  def destroy
    @organization_labor_category = OrganizationLaborCategory.find(params[:id])
    @organization_labor_category.destroy

    respond_to do |format|
      format.html { redirect_to organization_labor_categories_url }
      format.json { head :ok }
    end
  end
end
