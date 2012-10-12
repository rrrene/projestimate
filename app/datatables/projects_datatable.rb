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

class ProjectsDatatable < Project
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Project.count,
      iTotalDisplayRecords: projects.total_entries,
      aaData: data
    }
  end

private

  def data
    projects.map do |project|

       (project.baseline? || project.locked? || project.closed? ) ?
         commit = link_to('', '#', :class => "icn_commit") :
         commit = link_to('', {:controller => "projects", :action => "commit", :project_id => project.id }, :class => "icn_commit")
      [
        project.title.truncate(20),
        project.description.truncate(20),
        project.alias.truncate(20),
        project.state.humanize,
        project.start_date,
        project.organization.to_s,
        link_to('', {:controller => "projects", :action => "check_in", :project_id => project.id }, :class => "icn_check_in", :title => "Check in") +
        link_to('', {:controller => "projects", :action => "check_out", :project_id => project.id }, :class => "icn_check_out", :title => "Check out") +
        link_to('', "projects/#{project.id}/duplicate",  :class => "icn_duplicate", :title => "Duplicate") +
        commit +
        link_to('', {:controller => "projects", :action => "activate", :project_id => project.id }, :class => "icn_activate", :title => "Activate") +
        link_to('', "projects/#{project.id}/edit", :class => "icn_edit", :title => "Edit") +
        link_to('', {:controller => "projects", :action => "find_use", :project_id => project.id }, :remote => true, :class => "icn_find_use", :title => "Find use") +
        link_to('', project, confirm: 'Are you sure?', method: :delete, :class => "icn_trash", :title => "Delete")
      ]
    end
  end

  def projects
    @projects ||= fetch_projects
  end

  def fetch_projects
    projects = Project.order("#{sort_column} #{sort_direction}")
    projects = projects.page(page).per_page(per_page)
    if params[:sSearch].present?
      projects = projects.where(" title like :search or
                                  description like :search or
                                  alias like :search or
                                  state like :search",
                                  search: "%#{params[:sSearch]}%",
                                  search: "%#{params[:sSearch]}%",
                                  search: "%#{params[:sSearch]}%",
                                  search: "%#{params[:sSearch]}%")
    end
    projects
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[title description alias state start_date organization edit delete]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end