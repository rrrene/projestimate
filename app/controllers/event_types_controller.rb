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

class EventTypesController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

  def index
    authorize! :manage_event_types, EventType
    @event_types = EventType.all
  end

  def new
    authorize! :manage_event_types, EventType
    @event_type = EventType.new
  end

  def edit
    authorize! :manage_event_types, EventType
    @event_type = EventType.find(params[:id])
  end

  def create
    authorize! :manage_event_types, EventType
    @event_type = EventType.new(params[:event_type])
    redirect_to event_type_url
  end

  def update
    authorize! :manage_event_types, EventType
    @event_type = nil
    current_event_type = EventType.find(params[:id])
    if current_event_type.is_defined?
      @event_type = current_event_type.dup
    else
      @event_type = current_event_type
    end

    if @event_type.update_attributes(params[:event_type])
      redirect_to event_type_url, notice: 'Event ype was successfully updated.'
    else
      render action: "edit"
    end

  end

  def destroy
    authorize! :manage_event_types, EventType
    @event_type = EventType.find(params[:id])
    if @event_type.is_defined?
      #logical deletion: delete don't have to suppress records anymore on defined record
      @event_type.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
    else
      @event_type.destroy
    end

    flash[:notice] = "Event type was successfully deleted."
    redirect_to event_type_url
  end
end
