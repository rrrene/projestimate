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

class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    set_page_title("Events")
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  def create
    #@event = Event.new(params[:event])
    #redirect_to event_url
  end

  def update
    #@event = Event.find(params[:id])
    #redirect_to event_url
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to event_url
  end
end
