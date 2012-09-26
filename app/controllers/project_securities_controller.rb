class ProjectSecuritiesController < ApplicationController
  # GET /project_securities
  # GET /project_securities.json
  def index
    set_page_title "Projects Securities"
    @project_securitiy_levels = ProjectSecurityLevel.all
    @permissions = @permissions = Permission.all.select{|i| i.is_permission_project == true }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_securities }
    end
  end

  # GET /project_securities/new
  # GET /project_securities/new.json
  def new
    set_page_title "Project securities"
    @project_security = ProjectSecurity.new
    @projects = Project.all.map{|i| [i.title, i.id]}
    @users = []

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @project_security }
    end
  end

  # GET /project_securities/1/edit
  def edit
    set_page_title "Project securities"
    @project_security = ProjectSecurity.find(params[:id])
    @projects = Project.all.map{|i| [i.title, i.id]}
    @users = Project.find(@project_security.project.id).users.map{|i| [i.name, i.id]}
  end

  # POST /project_securities
  # POST /project_securities.json
  def create
    @project_security = ProjectSecurity.new(params[:project_security])

    respond_to do |format|
      if @project_security.save
        @project_security.update_attribute("project_security_level", params[:project_security_level])
        format.html { redirect_to project_securities_url, notice: 'Project security was successfully created.' }
        format.json { render json: @project_security, status: :created, location: @project_security }
      else
        format.html { render action: "new" }
        format.json { render json: @project_security.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /project_securities/1
  # PUT /project_securities/1.json
  def update
    @project_security = ProjectSecurity.find(params[:id])

    respond_to do |format|
      if @project_security.update_attributes(params[:project_security])
        @project_security.update_attribute("project_security_level", params[:project_security_level])
        format.html { redirect_to project_securities_url, notice: 'Project security was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_security.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_securities/1
  # DELETE /project_securities/1.json
  def destroy
    @project_security = ProjectSecurity.find(params[:id])
    @project_security.destroy

    respond_to do |format|
      format.html { redirect_to project_securities_url }
      format.json { head :ok }
    end
  end

  #Selcted users depending of selected project
  def select_users
    @users = Project.find(params[:project_selected]).users.map{|i| [i.name, i.id]}
  end
end
