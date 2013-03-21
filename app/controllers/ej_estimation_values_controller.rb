class EjEstimationValuesController < ApplicationController
  # GET /ej_estimation_values
  # GET /ej_estimation_values.json
  def index
    @ej_estimation_values = EjEstimationValue.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ej_estimation_values }
    end
  end

  # GET /ej_estimation_values/1
  # GET /ej_estimation_values/1.json
  def show
    @ej_estimation_value = EjEstimationValue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ej_estimation_value }
    end
  end

  # GET /ej_estimation_values/new
  # GET /ej_estimation_values/new.json
  def new
    @ej_estimation_value = EjEstimationValue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ej_estimation_value }
    end
  end

  # GET /ej_estimation_values/1/edit
  def edit
    @ej_estimation_value = EjEstimationValue.find(params[:id])
  end

  # POST /ej_estimation_values
  # POST /ej_estimation_values.json
  def create
    @ej_estimation_value = EjEstimationValue.new(params[:ej_estimation_value])

    respond_to do |format|
      if @ej_estimation_value.save
        format.html { redirect_to @ej_estimation_value, notice: 'Ej estimation value was successfully created.' }
        format.json { render json: @ej_estimation_value, status: :created, location: @ej_estimation_value }
      else
        format.html { render action: "new" }
        format.json { render json: @ej_estimation_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ej_estimation_values/1
  # PUT /ej_estimation_values/1.json
  def update
    @ej_estimation_value = EjEstimationValue.find(params[:id])

    respond_to do |format|
      if @ej_estimation_value.update_attributes(params[:ej_estimation_value])
        format.html { redirect_to @ej_estimation_value, notice: 'Ej estimation value was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ej_estimation_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ej_estimation_values/1
  # DELETE /ej_estimation_values/1.json
  def destroy
    @ej_estimation_value = EjEstimationValue.find(params[:id])
    @ej_estimation_value.destroy

    respond_to do |format|
      format.html { redirect_to ej_estimation_values_url }
      format.json { head :no_content }
    end
  end
end
