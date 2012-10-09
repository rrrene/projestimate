#encoding: utf-8
class GroupsController < ApplicationController

  def index
    authorize! :edit_groups, Group
    set_page_title "Groups"
    @groups = Group.all
  end

  def new
    authorize! :edit_groups, Group
    set_page_title "New group"
    @group = Group.new
    @users = User.all
    @projects = Project.all
  end

  def edit
    authorize! :edit_groups, Group
    set_page_title "Edit group"
    @group = Group.find(params[:id])
    @users = User.all
    @projects = Project.all
  end

  def create
    authorize! :edit_groups, Group
    @group = Group.new(params[:group])
    redirect_to groups_path
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])
    redirect_to groups_path
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :ok }
    end
  end
  
end
