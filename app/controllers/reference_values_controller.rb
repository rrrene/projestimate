class ReferenceValuesController < ApplicationController
  def index
    @reference_values = ReferenceValue.all
  end

  def edit
    @reference_value = ReferenceValue.find(params[:id])
  end

  def new
    @reference_value = ReferenceValue.new
  end

  def create
    @reference_value = ReferenceValue.new(params[:reference_value])
    @reference_value.save
    redirect_to redirect(reference_values_path)
  end

  def update
    @reference_value = ReferenceValue.find(params[:id])
    @reference_value.update_attributes(params[:reference_value])
    redirect_to redirect(reference_values_path)
  end

  def destroy
    @reference_value = ReferenceValue.find(params[:id])
    @reference_value.destroy
    redirect_to redirect(reference_values_path)
  end
end
