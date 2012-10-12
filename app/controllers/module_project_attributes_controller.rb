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

class ModuleProjectAttributesController < ApplicationController

  def edit
    set_page_title "Edit Module Project Attribute"
    @mpa = ModuleProjectAttribute.find(params[:id])
  end

  def update
    @mpa = Language.find(params[:id])

    respond_to do |format|
      if @mpa.update_attributes(params[:module_project_attribute])
        format.html { redirect_to @mpa, notice: 'MPA was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @mpa.errors, status: :unprocessable_entity }
      end
    end
  end
end
