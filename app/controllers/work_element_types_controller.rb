class WorkElementTypesController < ApplicationController

  def index
    authorize! :manage_wet, WorkElementType
    set_page_title "Work Element Type"
    @work_element_types = WorkElementType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @work_element_types }
    end
  end

  def new
    authorize! :manage_wet, WorkElementType
    set_page_title "Work Element Type"
    @work_element_type = WorkElementType.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @work_element_type }
    end
  end

  # GET /work_element_types/1/edit
  def edit
    authorize! :manage_wet, WorkElementType
    set_page_title "Work Element Type"
    @work_element_type = WorkElementType.find(params[:id])
  end

  def create
    authorize! :manage_wet, WorkElementType
    @work_element_type = WorkElementType.new(params[:work_element_type])

    respond_to do |format|
      if @work_element_type.save
        format.html { redirect_to work_element_type_url, notice: 'Work element type was successfully created.' }
        format.json { render json: @work_element_type, status: :created, location: @work_element_type }
      else
        format.html { render action: "new" }
        format.json { render json: @work_element_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :manage_wet, WorkElementType
    @work_element_type = WorkElementType.find(params[:id])

    respond_to do |format|
      if @work_element_type.update_attributes(params[:work_element_type])
        format.html { redirect_to work_element_type_url, notice: 'Work element type was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @work_element_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :manage_wet, WorkElementType
    @work_element_type = WorkElementType.find(params[:id])
    @work_element_type.destroy

    redirect_to work_element_types_url
  end
end
