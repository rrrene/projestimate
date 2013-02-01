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

class AttributesController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

  def index
    authorize! :manage_attributes, Attribute
    set_page_title "Attributes"
    @attributes = Attribute.all
  end

  def new
    authorize! :manage_attributes, Attribute
    set_page_title "Attributes"
    @attribute = Attribute.new
  end

  def edit
    authorize! :manage_attributes, Attribute
    set_page_title "Attributes"
    @attribute = Attribute.find(params[:id])

    unless @attribute.child_reference.nil?
      if @attribute.child_reference.is_proposed_or_custom?
        flash[:notice] = "This Attribute can't be edited, because the previous changes have not yet been validated."
        redirect_to attributes_path
      end
    end
  end

  def create
    authorize! :manage_attributes, Attribute
    set_page_title "Attributes"
    @attribute = Attribute.new(params[:attribute])
    @attribute.options = params[:options]
    @attribute.attr_type = params[:options][0]

    if @attribute.save
      redirect_to redirect(attributes_path)
    else
      render action: "new"
    end
  end

  def update
    set_page_title "Attributes"
    authorize! :manage_attributes, Attribute
    @attribute = nil
    current_attribute = Attribute.find(params[:id])
    if current_attribute.is_defined?
      @attribute = current_attribute.amoeba_dup
      @attribute.owner_id = current_user.id
    else
      @attribute = current_attribute
    end

    if @attribute.update_attributes(params[:attribute])
      if @attribute.update_attribute("options", params[:options])
        @attribute.attr_type = params[:options][0]
        if @attribute.save
          redirect_to redirect(attributes_path)
        else
          render action: "edit"
        end
      else
        render action: "edit"
      end
    else
      render action: "edit"
    end
  end

  def destroy
    authorize! :manage_attributes, Attribute
    @attribute = Attribute.find(params[:id])
    if @attribute.is_defined? || @attribute.is_custom?
      #logical deletion: delete don't have to suppress records anymore on defined record
      @attribute.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
    else
      @attribute.destroy
    end

    redirect_to attributes_path
  end
end
