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

class ReferenceValuesController < ApplicationController
  include DataValidationHelper

  before_filter :get_record_statuses

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

    #If we are on local instance, Status is set to "Local"
    if is_master_instance?
      @reference_value.record_status = @proposed_status
    else
      @reference_value.record_status = @local_status
    end

    if @reference_value.save
      redirect_to redirect_apply(nil, new_reference_value_path(), reference_values_path, )
    else
      render action: 'new'
    end
  end

  def update
    @reference_value = nil
    current_reference_value = ReferenceValue.find(params[:id])

    if current_reference_value.is_defined? && is_master_instance?
      @reference_value = current_reference_value.amoeba_dup
      @reference_value.owner_id = current_user.id
    else
      @reference_value = current_reference_value
    end

    unless is_master_instance?
      if @reference_value.is_local_record?
        @reference_value.custom_value = 'Locally edited'
      end
    end

    if @reference_value.update_attributes(params[:reference_value])
      redirect_to redirect_apply(edit_reference_value_path(@reference_value),nil,reference_values_path )
    else
      render :edit
    end
  end

  def destroy
  @reference_value = ReferenceValue.find(params[:id])
    if is_master_instance?
      if @reference_value.is_defined? || @reference_value.is_custom?
        #logical deletion: delete don't have to suppress records anymore on defined record
        @reference_value.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
      else
        @reference_value.destroy
      end
    else
      if @reference_value.is_local_record? || @reference_value.is_retired?
        @reference_value.destroy
      else
        flash[:warning] = I18n.t (:warning_master_record_cant_be_delete)
        redirect_to redirect(reference_values_path)  and return
      end
    end

    flash[:notice] = I18n.t (:notice_reference_value_successful_deleted)
    redirect_to reference_values_path
  end
end
