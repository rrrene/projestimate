class WbsProjectElementsController < ApplicationController
  helper_method :disabled_if_from_library

  def disabled_if_from_library
    if params[:action] == "new"
      false
    else
      if @wbs_project_element.wbs_activity.nil?
        false
      else
        true
      end
    end
  end


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

    @project = Project.find(params[:project_id])
    @pe_wbs_project = @project.pe_wbs_projects.wbs_activity.first


    if @wbs_project_element.is_root
      @selected_parent = nil
      @potential_parents = nil
    else
      @selected_parent ||= WbsProjectElement.find_by_id(params[:selected_parent_id])
      @potential_parents = @pe_wbs_project.wbs_project_elements
    end
  end

  # POST /wbs_project_elements
  # POST /wbs_project_elements.json
  def create
    @wbs_project_element = WbsProjectElement.new(params[:wbs_project_element])
    @wbs_project_element.author_id = current_user.id

    @project = Project.find(params[:project_id])
    #@selected_parent ||= WbsProjectElement.find_by_id(params[:selected_parent_id])
    @selected_parent ||= params[:parent_id]

    @pe_wbs_project = @project.pe_wbs_projects.wbs_activity.first
    @potential_parents = @pe_wbs_project.wbs_project_elements

    if @wbs_project_element.save
     redirect_to edit_project_path(@project, :anchor => "tabs-3"), notice: 'Wbs project element was successfully created.'

    else
      render action: "new"
    end
  end

  # PUT /wbs_project_elements/1
  # PUT /wbs_project_elements/1.json
  def update
    @wbs_project_element = WbsProjectElement.find(params[:id])
    @project = Project.find(params[:project_id])

    #@selected_parent ||= WbsProjectElement.find_by_id(params[:selected_parent_id])
    @selected_parent ||= params[:parent_id]
    @pe_wbs_project = @project.pe_wbs_projects.wbs_activity.first
    @potential_parents = @pe_wbs_project.wbs_project_elements

    respond_to do |format|
      if @wbs_project_element.update_attributes(params[:wbs_project_element])
        format.html { redirect_to edit_project_path(@project, :anchor => "tabs-3"), notice: 'Wbs project element was successfully updated.' }
        format.json { head :no_content }
      else
        flash[:error] = @wbs_project_element.errors.full_messages.to_sentence
        format.html { render action: "edit" }
        format.json { render json: @wbs_project_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wbs_project_elements/1
  # DELETE /wbs_project_elements/1.json
  def destroy
    @wbs_project_element = WbsProjectElement.find(params[:id])
    @project = Project.find(params[:project_id])

    if @wbs_project_element.destroy
      @project.included_wbs_activities.delete(@wbs_project_element.wbs_activity_id)
      @project.save
    end

    respond_to do |format|
      #format.html { redirect_to edit_project_path(@project), :notice => 'Wbs-Project-Element was successfully deleted.' }
      format.html { redirect_to edit_project_path(@project, :anchor => "tabs-3"), :notice => 'Wbs-Project-Element was successfully deleted.' }

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
