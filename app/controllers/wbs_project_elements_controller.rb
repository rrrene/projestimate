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

    @selected_parent ||= WbsProjectElement.find_by_id(params[:selected_parent_id])
    @project = Project.find(params[:project_id])
    @pe_wbs_project = @project.pe_wbs_projects.wbs_activity.first
    @potential_parents = @pe_wbs_project.wbs_project_elements

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
    @wbs_project_element.author_id = current_user.id

    if @wbs_project_element.save
     redirect_to @wbs_project_element, notice: 'Wbs project element was successfully created.'

    else
      render action: "new"
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

  #Select the current pbs_project_element and refresh the partial
  def selected_wbs_project_element
    session[:wbs_project_element_id] = params[:id]

    @user = current_user
    @project = current_project
    @wbs_project_element = current_wbs_project_element
    @array_module_positions = ModuleProject.where(:project_id => @project.id).sort_by{|i| i.position_y}.map(&:position_y).uniq.max || 1

    render :partial => "wbs_project_elements/refresh"
  end

end
