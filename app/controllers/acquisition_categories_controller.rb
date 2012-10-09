class AcquisitionCategoriesController < ApplicationController

  def new
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.new
  end

  def edit
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.find(params[:id])
  end

  def create
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.new(params[:acquisition_category])
    flash[:notice] = 'Acquisition category was successfully created.'
    redirect_to "/projects_global_params"
  end

  def update
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.find(params[:id])
    flash[:notice] = 'Acquisition category was successfully updated.'
    redirect_to "/projects_global_params"
  end

  def destroy
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.find(params[:id])
    @acquisition_category.destroy
    flash[:notice] = 'Acquisition category was successfully deleted.'
    redirect_to "/projects_global_params"
  end
end
