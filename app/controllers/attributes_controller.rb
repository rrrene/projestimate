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
  end

  def create
    authorize! :manage_attributes, Attribute
    set_page_title "Attributes"
    @attribute = Attribute.new(params[:attribute])
    if @attribute.save
      redirect_to attributes_path
    else
       render action: "new"
    end
  end

  #TODO: refactoring
  def update
    set_page_title "Attributes"
    authorize! :manage_attributes, Attribute
    @attribute = Attribute.find(params[:id])
    if @attribute.update_attributes(params[:attribute])
      if @attribute.update_attribute("options", params[:options])
        @attribute.attr_type = params[:options][0]
        if @attribute.save
          redirect_to attributes_path
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
    @attribute.destroy

    redirect_to attributes_path
  end
end
