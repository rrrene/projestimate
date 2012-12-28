#encoding: utf-8
#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012 Spirula (http://www.spirula.fr)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
########################################################################

class GroupsController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

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
    if @group.save
      redirect_to redirect(groups_path)
    else
      render action: "new"
    end
  end

  def update
    @users = User.all
    @projects = Project.all
    @group = nil
    current_group = Group.find(params[:id])
    if current_group.is_defined?
      @group = current_group.dup
    else
      @group = current_group
    end

    if @group.update_attributes(params[:group])
      redirect_to redirect(groups_path)
    else
      render action: "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.is_defined
      #logical deletion: delete don't have to suppress records anymore on defined record
      @group.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
    else
      @group.destroy
    end
    flash[:notice] = "Group was successfully deleted."
    redirect_to groups_url
  end
end
