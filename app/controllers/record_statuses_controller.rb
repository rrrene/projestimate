#encoding: utf-8
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

class RecordStatusesController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

  def index
    @record_statuses = RecordStatus.all
  end

  def show
    @record_status = RecordStatus.find(params[:id])
  end

  def new
    @record_status = RecordStatus.new
  end

  def edit
    @record_status = RecordStatus.find(params[:id])
  end

  def create
    @record_status = RecordStatus.new(params[:record_status])

    respond_to do |format|
      if @record_status.save
        format.html { redirect_to @record_status, notice: 'Record status was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    current_record_status = RecordStatus.find(params[:id])
    @record_status = current_record_status.dup

    respond_to do |format|
      if @record_status.update_attributes(params[:record_status])
        format.html { redirect_to @record_status, notice: 'Record status was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @record_status = RecordStatus.find(params[:id])
    #logical deletion: delete don't have to suppress records anymore
    @record_status.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)

    respond_to do |format|
      format.html { redirect_to record_statuses_url }
    end
  end
end
