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

class EstimationValuesController < ApplicationController

  def edit
    set_page_title 'Edit Module Project Attribute'
    @est_value = EstimationValue.find(params[:id])
  end

  def update
    @est_value = EstimationValue.find(params[:id])

    respond_to do |format|
      if @est_value.update_attributes(params[:estimation_value])
        format.html { redirect_to redirect_save(@est_value), notice: "#{I18n.t (:notice_estimation_value_successful_updated)}" }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def convert
    res = Array.new
    @data = String.new
    current_project.module_projects.each do |module_project|
      module_project.estimation_values.each do |est_val|
        res << est_val.string_data_low
        res << est_val.string_data_most_likely
        res << est_val.string_data_high
      end
    end

    #res.each do |r|
      if params[:type] == "json"
        @data << res.first.to_json
      elsif params[:type] == "xml"
        @data << res.first.to_xml
      elsif params[:type] == "csv"
        @data << res.first.to_csv
      end
    #end

    send_data(@data, :type => "text/#{params[:type]}; header=present", :disposition => "attachment; filename=data.#{params[:type]}")

  end

  def generate_pdf
    #pdf = PDFKit.new('/404.html')
    #send_data(pdf, :type => "application/pdf", :disposition => "inline", :filename => "data.pdf")
  end

end