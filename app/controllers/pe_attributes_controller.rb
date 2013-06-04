#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012-2013 Spirula (http://www.spirula.fr)
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

class PeAttributesController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

  def index
    authorize! :manage_attributes, PeAttribute
    set_page_title "Attributes"
    @attributes = PeAttribute.all
  end

  def new
    authorize! :manage_attributes, PeAttribute
    set_page_title "Attributes"
    @attribute = PeAttribute.new
  end

  def edit
    authorize! :manage_attributes, PeAttribute
    set_page_title "Attributes"
    @attribute = PeAttribute.find(params[:id])

    unless @attribute.child_reference.nil?
      if @attribute.child_reference.is_proposed_or_custom?
        flash[:warning] = I18n.t (:warning_attribute_cant_be_edit)
        redirect_to attributes_path
      end
    end
  end

  def create
    authorize! :manage_attributes, PeAttribute
    set_page_title "Attributes"
    @attribute = PeAttribute.new(params[:pe_attribute])
    @attribute.options = params[:options]
    @attribute.attr_type = params[:options][0]

    if @attribute.save
      redirect_to redirect(pe_attributes_path)
    else
      render action: "new"
    end
  end

  def update
    set_page_title "Attributes"
    authorize! :manage_attributes, PeAttribute
    @attribute = nil
    current_attribute = PeAttribute.find(params[:id])
    if current_attribute.is_defined?
      @attribute = current_attribute.amoeba_dup
      @attribute.owner_id = current_user.id
    else
      @attribute = current_attribute
    end

    if @attribute.update_attributes(params[:pe_attribute]) and @attribute.update_attribute("options", params[:options])
      @attribute.attr_type = params[:options][0]
      if @attribute.save
        redirect_to redirect(pe_attributes_path)
      else
        render action: "edit"
      end
    end
  end

  def destroy
    authorize! :manage_attributes, PeAttribute
    @attribute = PeAttribute.find(params[:id])
    if @attribute.is_defined? || @attribute.is_custom?
      #logical deletion: delete don't have to suppress records anymore on defined record
      @attribute.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
    else
      @attribute.destroy
    end
    redirect_to pe_attributes_path
  end

  def check_attribute
    if params[:est_val_id]
      @ev = EstimationValue.find(params[:est_val_id])
      @is_valid = @ev.is_validate(params[:value])
      test = params[:value]
      @level = params[:level]
      @est_val_id = params[:est_val_id]
      params[:wbs_project_elt_id].eql?("undefined") ? @wbs_project_elt_id = nil : @wbs_project_elt_id = params[:wbs_project_elt_id].eql?
    end
  end
end
