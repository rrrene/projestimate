#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012 Spirula (http://www.spirula.fr)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
########################################################################

class AcquisitionCategoriesController < ApplicationController

  def new
    authorize! :manage_acquisition_categories, AcquisitionCategory
    set_page_title "Acquisition Category"
    @acquisition_category = AcquisitionCategory.new
  end

  def edit
    authorize! :manage_acquisition_categories, AcquisitionCategory
    set_page_title "Acquisition Category"
    @acquisition_category = AcquisitionCategory.find(params[:id])
  end

  def create
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.new(params[:acquisition_category])
    if @acquisition_category.save
      flash[:notice] = "Acquisition category was successfully created."
      redirect_to "/projects_global_params"
    else
      render action: "edit"
    end
  end

  def update
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.find(params[:id])
    if @acquisition_category.update_attributes(params[:acquisition_category])
      flash[:notice] = "Acquisition category was successfully updated."
      redirect_to "/projects_global_params"
    else
      render action: "edit"
    end
  end

  def destroy
    authorize! :manage_acquisition_categories, AcquisitionCategory
    @acquisition_category = AcquisitionCategory.find(params[:id])
    @acquisition_category.destroy
    flash[:notice] = 'Acquisition category was successfully deleted.'
    redirect_to "/projects_global_params"
  end
end
