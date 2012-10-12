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

class AttributeModulesController < ApplicationController

  def create
    @attribute_module = AttributeModule.new(params[:attribute_module])

    respond_to do |format|
      if @attribute_module.save
        format.html { redirect_to @attribute_module, notice: 'Attribute module was successfully created.' }
        format.json { render json: @attribute_module, status: :created, location: @attribute_module }
      else
        format.html { render action: "new" }
        format.json { render json: @attribute_module.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @attribute_module = AttributeModule.find(params[:id])
    @attribute_module.destroy

    respond_to do |format|
      format.html { redirect_to attribute_modules_url }
      format.json { head :ok }
    end
  end

end
