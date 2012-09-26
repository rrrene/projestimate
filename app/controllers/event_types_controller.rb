class EventTypesController < ApplicationController
  def index
    authorize! :manage_event_types, EventType
    @event_types = EventType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_types }
    end
  end

  def show
    authorize! :manage_event_types, EventType
    @event_type = EventType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event_type }
    end
  end

  def new
    authorize! :manage_event_types, EventType
    @event_type = EventType.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @event_type }
    end
  end

  def edit
    authorize! :manage_event_types, EventType
    @event_type = EventType.find(params[:id])
  end

  def create
    authorize! :manage_event_types, EventType
    @event_type = EventType.new(params[:event_type])

    respond_to do |format|
      if @event_type.save
        format.html { redirect_to @event_type, notice: 'Event type was successfully created.' }
        format.json { render json: @event_type, status: :created, location: @event_type }
      else
        format.html { render action: "new" }
        format.json { render json: @event_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :manage_event_types, EventType
    @event_type = EventType.find(params[:id])

    respond_to do |format|
      if @event_type.update_attributes(params[:event_type])
        format.html { redirect_to @event_type, notice: 'Event type was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :manage_event_types, EventType
    @event_type = EventType.find(params[:id])
    @event_type.destroy

    respond_to do |format|
      format.html { redirect_to event_types_url }
      format.json { head :ok }
    end
  end
end
