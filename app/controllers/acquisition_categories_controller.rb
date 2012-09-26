class AcquisitionCategoriesController < ApplicationController
  def index
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_categories = AcquisitionCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @acquisition_categories }
    end
  end

  def show
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @acquisition_category }
    end
  end

  def new
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @acquisition_category }
    end
  end

  def edit
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.find(params[:id])
  end

  def create
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.new(params[:acquisition_category])

    respond_to do |format|
      if @acquisition_category.save
        format.html { redirect_to "/projects_global_params", notice: 'Acquisition category was successfully created.' }
        format.json { render json: @acquisition_category, status: :created, location: @acquisition_category }
      else
        format.html { render action: "new" }
        format.json { render json: @acquisition_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.find(params[:id])

    respond_to do |format|
      if @acquisition_category.update_attributes(params[:acquisition_category])
        format.html { redirect_to "/projects_global_params", notice: 'Acquisition category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @acquisition_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.find(params[:id])
    @acquisition_category.destroy

    respond_to do |format|
      format.html { redirect_to acquisition_categories_url }
      format.json { head :ok }
    end
  end
end
