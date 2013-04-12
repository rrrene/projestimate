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

class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    set_page_title('Events')
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
    @event = Event.new(params[:event])
    if @event.save
      redirect_to redirect(events_path)
    else
      render action: 'new'
    end
  end

  def update
    @event = nil
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to events_path, notice: "#{I18n.t (:notice_event_successful_updated)}"
    else
      render action: 'edit'
    end

  end

  def destroy
    #@event = Event.find(params[:id])
    #@event.destroy
    #redirect_to event_url
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path
  end
end
