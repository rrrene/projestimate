class LaborCategoriesController < ApplicationController

  # GET /labor_categories
  # GET /labor_categories.json
  def index
    set_page_title "Labors Categories"
    authorize! :manage_labor_categories, LaborCategory
    @labor_categories = LaborCategory.all
  end

  # GET /labor_categories/1
  # GET /labor_categories/1.json
  def show
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @labor_category }
    end
  end

  # GET /labor_categories/new
  # GET /labor_categories/new.json
  def new
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @labor_category }
    end
  end

  # GET /labor_categories/1/edit
  def edit
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.find(params[:id])
  end

  # POST /labor_categories
  # POST /labor_categories.json
  def create
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.new(params[:labor_category])

    respond_to do |format|
      if @labor_category.save
        format.html { redirect_to @labor_category, notice: 'Labor category was successfully created.' }
        format.json { render json: @labor_category, status: :created, location: @labor_category }
      else
        format.html { render action: "new" }
        format.json { render json: @labor_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /labor_categories/1
  # PUT /labor_categories/1.json
  def update
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.find(params[:id])

    respond_to do |format|
      if @labor_category.update_attributes(params[:labor_category])
        format.html { redirect_to @labor_category, notice: 'Labor category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @labor_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /labor_categories/1
  # DELETE /labor_categories/1.json
  def destroy
    authorize! :manage_labor_categories, LaborCategory
    @labor_category = LaborCategory.find(params[:id])
    @labor_category.destroy

    respond_to do |format|
      format.html { redirect_to labor_categories_url }
      format.json { head :ok }
    end
  end

end
