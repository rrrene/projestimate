#encoding: utf-8
class PermissionsController < ApplicationController
  # GET /permissions
  # GET /permissions.json
  def index
    set_page_title "Permissions listings"
    @permissions = Permission.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @permissions }
    end
  end

  def globals_permissions
    authorize! :manage_permissions, Permission
    set_page_title "Globals Permissions"
    @permissions = Permission.all.select{|i| i.is_permission_project == false }
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @permissions }
    end
  end

  # GET /permissions/1
  # GET /permissions/1.json
  def show
    authorize! :manage_permissions, Permission
    @permission = Permission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @permission }
    end
  end

  # GET /permissions/new
  # GET /permissions/new.json
  def new
    authorize! :manage_permissions, Permission
    set_page_title "Permissions"
    @permission = Permission.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @permission }
    end
  end

  # GET /permissions/1/edit
  def edit
    authorize! :manage_permissions, Permission
    set_page_title "Permissions"
    @permission = Permission.find(params[:id])
  end

  # POST /permissions
  # POST /permissions.json
  def create
    @permission = Permission.new(params[:permission])

    @groups = Group.all

    respond_to do |format|
      if @permission.save
        format.html { redirect_to "/admin", notice: 'Function was successfully created.' }
        format.json { render json: @permission, status: :created, location: @permission }
      else
        format.html { render action: "new" }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /permissions/1
  # PUT /permissions/1.json
  def update
    @permission = Permission.find(params[:id])

    respond_to do |format|
      if @permission.update_attributes(params[:permission])
        @permission.update_attribute :parent, Permission.find(params[:permission_parent_id])
        @permission.name = String.keep_clean_space(@permission.name.to_s)
        @permission.save

        format.html { redirect_to "/globals_permissions", notice: 'Function was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permissions/1
  # DELETE /permissions/1.json
  def destroy
    @permission = Permission.find(params[:id])
    @permission.destroy

    respond_to do |format|
      format.html { redirect_to permissions_path }
      format.json { head :ok }
    end
  end

  #Set all global rights
  def set_rights
    authorize! :manage_permissions, Permission
    @groups = Group.all
    @permissions = Permission.all

    @groups.each do |group|
      group.update_attribute("permission_ids", params[:permissions][group.id.to_s])
    end

    respond_to do |format|
      format.html { redirect_to permissions_path, :notice => "Permissions saved succesfully" }
    end

  end

  #Set all project security rights
  def set_rights_project_security
    authorize! :manage_specific_permissions, Permission
    @project_security_levels = ProjectSecurityLevel.all
    @permissions = Permission.all

    @project_security_levels.each do |psl|
      psl.update_attribute("permission_ids", params[:permissions][psl.id.to_s])
    end

    respond_to do |format|
      format.html { redirect_to project_securities_path, :notice => "Permissions saved succesfully" }
    end

  end
end
