class WbsProjectElementsController < ApplicationController
  # GET /wbs_project_elements
  # GET /wbs_project_elements.json
  def index
    @wbs_project_elements = WbsProjectElement.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wbs_project_elements }
    end
  end

  # GET /wbs_project_elements/1
  # GET /wbs_project_elements/1.json
  def show
    @wbs_project_element = WbsProjectElement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wbs_project_element }
    end
  end

  # GET /wbs_project_elements/new
  # GET /wbs_project_elements/new.json
  def new
    @wbs_project_element = WbsProjectElement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wbs_project_element }
    end
  end

  # GET /wbs_project_elements/1/edit
  def edit
    @wbs_project_element = WbsProjectElement.find(params[:id])
  end

  # POST /wbs_project_elements
  # POST /wbs_project_elements.json
  def create
    @wbs_project_element = WbsProjectElement.new(params[:wbs_project_element])

    respond_to do |format|
      if @wbs_project_element.save
        format.html { redirect_to @wbs_project_element, notice: 'Wbs project element was successfully created.' }
        format.json { render json: @wbs_project_element, status: :created, location: @wbs_project_element }
      else
        format.html { render action: "new" }
        format.json { render json: @wbs_project_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /wbs_project_elements/1
  # PUT /wbs_project_elements/1.json
  def update
    @wbs_project_element = WbsProjectElement.find(params[:id])

    respond_to do |format|
      if @wbs_project_element.update_attributes(params[:wbs_project_element])
        format.html { redirect_to @wbs_project_element, notice: 'Wbs project element was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @wbs_project_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wbs_project_elements/1
  # DELETE /wbs_project_elements/1.json
  def destroy
    @wbs_project_element = WbsProjectElement.find(params[:id])
    @wbs_project_element.destroy

    respond_to do |format|
      format.html { redirect_to wbs_project_elements_url }
      format.json { head :no_content }
    end
  end
end
