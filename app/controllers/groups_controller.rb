#encoding: utf-8
#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012-2013 Spirula (http://www.spirula.fr)
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

  helper_method :enable_update_in_local?
  helper_method :user_organizations_users
  helper_method :user_organizations_projects

  def index
    authorize! :manage_users, Group
    set_page_title 'Groups'
    @groups = Group.all
  end

  def new
    authorize! :manage_users, Group
    set_page_title 'New group'
    @group = Group.new
    @users = User.all
    @projects = Project.all
    @enable_update_in_local = true
  end

  def edit
    authorize! :manage_users, Group
    set_page_title 'Edit group'
    @group = Group.find(params[:id])
    @users = User.all
    @projects = Project.all

    if is_master_instance?
      @enable_update_in_local = true
      unless @group.child_reference.nil?
        if @group.child_reference.is_proposed_or_custom?
          flash[:warning] = I18n.t (:warning_group_cant_be_edit)
          redirect_to groups_path and return
        end
      end
    else
      if @group.is_local_record?
        @group.record_status = @local_status
        @enable_update_in_local = true
        ##flash[:notice] = "testing"
      else
        @enable_update_in_local = false
        #  flash[:error] = "Master record can not be edited, it is required for the proper functioning of the application"
        #  redirect_to redirect(groups_path)
      end
    end

  end

  def create
    authorize! :manage_users, Group
    @users = User.all
    @projects = Project.all
    @group = Group.new(params[:group])
    @enable_update_in_local = true

    #If we are on local instance, Status is set to "Local"
    if is_master_instance?
      @group.record_status = @proposed_status
    else
      @group.record_status = @local_status
    end

    if @group.save
      redirect_to redirect(groups_path)
    else
      render action: 'new'
    end
  end

  def update
    authorize! :manage_users, Group
    @users = User.all
    @projects = Project.all
    @group = nil
    current_group = Group.find(params[:id])

    if current_group.is_defined? && is_master_instance?
      @enable_update_in_local = true
      @group = current_group.amoeba_dup
      @group.owner_id = current_user.id
    else
      @group = current_group
    end

    if is_master_instance?
      @enable_update_in_local = true
    else
      if @group.is_local_record?
        @enable_update_in_local = true
        @group.custom_value = 'Locally edited'
      else
        @enable_update_in_local = false
      end
    end

    if @group.update_attributes(params[:group])
      redirect_to redirect(groups_path), :notice => "#{I18n.t (:notice_group_successful_updated)}"
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize! :manage_users, Group

    @group = Group.find(params[:id])
    if is_master_instance?
      if @group.is_defined? || @group.is_custom?
        #logical deletion: delete don't have to suppress records anymore on defined record
        @group.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
      else
        @group.destroy
      end
    else
      if @group.is_local_record? || @group.is_retired?
        @group.destroy
      else
        flash[:error] = I18n.t (:warning_master_record_cant_be_delete)
        redirect_to redirect(groups_path) and return
      end
    end

    flash[:notice] = I18n.t (:notice_group_successful_deleted)
    redirect_to groups_url
  end

  def enable_update_in_local?
    authorize! :manage_users, Group

    if is_master_instance?
      true
    else
      if params[:action] == 'new'
        true
      elsif params[:action] == 'edit'
        @group = Group.find(params[:id])
        if @group.is_local_record?
          true
        else
          if params[:anchor] == 'tabs-1'
            false
          end
        end
      end
    end
  end


  def associated_users
    authorize! :manage_users, Group
    @group = Group.find(params[:id])
  end

  def associated_projects
    authorize! :manage_users, Group
    @group = Group.find(params[:id])
  end

  def user_organizations_users
    authorize! :manage_users, Group

    users = []
    organizations = current_user.organizations
    organizations.each do |org|
      users = users + org.users
    end
    users
  end

  def user_organizations_projects
    authorize! :manage_users, Group

    projects = []
    organizations = current_user.organizations
    organizations.each do |org|
      projects = projects + org.projects
    end
    projects
  end

end
