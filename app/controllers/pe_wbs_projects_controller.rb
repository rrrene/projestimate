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

#encoding: utf-8
class PeWbsProjectsController < ApplicationController

  #def new
  #  set_page_title "New PE-WBS-Project"
  #end
  #
  #def create
  #  @pe_wbs_project = PeWbsProject.new(params[:pe_wbs_project])
  #
  #  #New root Pbs-Project-Element
  #  pbs_project_element = @pe_wbs_project.pbs_project_elements.build(:name => "WBS-Product - Product Breakdown Structure", :is_root => true, :work_element_type_id => default_work_element_type.id, :position => 0)
  #
  #  wbs_activity = @pe_wbs_project.wbs_project_elements.build(:name => "WBS-Activity - Activity breakdown Structure", :description => "WBS-Activity Root Element")
  #
  #  @pe_wbs_project.transaction do
  #    if @pe_wbs_project.save
  #      pbs_project_element.save
  #
  #      redirect_to redirect(@pe_wbs_project.projects_path), notice: 'Project and Elements were successfully created.'
  #    else
  #      render action: "new"
  #    end
  #
  #  end
  #
  #end

end
