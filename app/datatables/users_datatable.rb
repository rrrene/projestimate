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

class UsersDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: User.count,
      iTotalDisplayRecords: users.total_entries,
      aaData: data
    }
  end

private

  def data
    users.map do |user|
      [
        user.first_name,
        user.surename,
        user.user_name,
        user.email,
        user.last_login,
        user.auth_method.to_s,
        user.user_status,
        link_to('', "users/#{user.id}/edit", :class => "icn_edit", :title => "Edit") +
        link_to('', "users/#{user.id}/activate", :class => "icn_jump_back", :title => "Activate") +
        link_to('', {:controller => "users", :action => "find_use_user", :user_id => user.id }, :remote => true, :class => "icn_find_use", :title => "Find Use") +
        link_to('', user, confirm: 'Are you sure?', method: :delete, :class => "icn_trash", :title => "Delete")
      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.order("#{sort_column} #{sort_direction}")
    users = users.page(page).per_page(per_page)
    if params[:sSearch].present?
      users = users.where(" first_name like :search or
                            surename like :search or
                            user_name like :search or
                            email like :search",
                            search: "%#{params[:sSearch]}%",
                            search: "%#{params[:sSearch]}%",
                            search: "%#{params[:sSearch]}%",
                            search: "%#{params[:sSearch]}%")
    end
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[first_name surename user_name email time_zone languages auth_method user_status edit delete]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end