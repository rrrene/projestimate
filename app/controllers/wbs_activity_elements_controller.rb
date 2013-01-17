class WbsActivityElementsController < ApplicationController
  include PeWbsHelper

  def index
    set_page_title "WBS-Activity elements"
    @wbs_activity_elements = WbsActivityElement.all
  end

  def show
    set_page_title "WBS-Activity elements"
    @wbs_activity_element = WbsActivityElement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wbs_activity_element }
    end
  end

  def new
    set_page_title "WBS-Activity elements"
    @wbs_activity_element = WbsActivityElement.new
  end

  def edit
    set_page_title "WBS-Activity elements"
    @wbs_activity_element = WbsActivityElement.find(params[:id])
  end

  def create
    @wbs_activity_element = WbsActivityElement.new(params[:wbs_activity_element])

    if @wbs_activity_element.save
      redirect_to wbs_activity_elements_path, notice: 'Wbs activity element was successfully created.'
    else
       render action: "new"
    end
  end

  def update
    @wbs_activity_element = WbsActivityElement.find(params[:id])

    if @wbs_activity_element.update_attributes(params[:wbs_activity_element])
      redirect_to wbs_activity_elements_path, notice: 'Wbs activity element was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @wbs_activity_element = WbsActivityElement.find(params[:id])
    @wbs_activity_element.destroy

    respond_to do |format|
      format.html { redirect_to wbs_activity_elements_url }
      format.json { head :no_content }
    end
  end

end
