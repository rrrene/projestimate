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

class EstimationValuesController < ApplicationController

  def edit
    set_page_title 'Edit Module Project Attribute'
    @est_value = EstimationValue.find(params[:id])
  end

  def update
    @est_value = EstimationValue.find(params[:id])

    respond_to do |format|
      if @est_value.update_attributes(params[:estimation_value])
        format.html { redirect_to redirect(@est_value), notice: "#{I18n.t (:notice_estimation_value_successful_updated)}" }
      else
        format.html { render action: 'edit' }
      end
    end
  end
end
