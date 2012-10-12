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
    @event_type = EventType.find(params[:id])
    redirect_to event_type_url
  end

  def destroy
    authorize! :manage_event_types, EventType
    @event_type = EventType.find(params[:id])
    @event_type.destroy
    redirect_to event_type_url
  end
end
