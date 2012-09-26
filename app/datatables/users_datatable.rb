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
        user.time_zone,
        user.language.nil? ? '-' : user.language.name,
        user.type_auth,
        user.user_status,
        link_to('Edit', "users/#{user.id}/edit"),
        link_to('Find use', {:controller => "users", :action => "find_use_user", :user_id => user.id }, :remote => true),
        link_to('Destroy', user, confirm: 'Are you sure?', method: :delete)
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
                            initial like :search or
                            email like :search",
                            search: "%#{params[:sSearch]}%",
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
    columns = %w[first_name surename user_name email time_zone languages type_auth user_status edit delete]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end