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
