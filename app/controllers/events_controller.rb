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
    @event = Event.new(params[:event])
    redirect_to event_url
  end

  def update
    @event = Event.find(params[:id])
    redirect_to event_url
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to event_url
  end
end
