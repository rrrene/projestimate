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
      [
        project.title.truncate(20),
        project.description.truncate(20),
        project.alias.truncate(20),
        project.state.humanize,
        project.start_date,
        project.organization.to_s,
        link_to('Check-in', {:controller => "projects", :action => "check_in", :project_id => project.id }),
        link_to('Check-out', {:controller => "projects", :action => "check_out", :project_id => project.id }),
        link_to('Duplicate', "projects/#{project.id}/duplicate"),
        (project.baseline? || project.locked? || project.closed? ) ? 'Commit' : link_to('Commit', {:controller => "projects", :action => "commit", :project_id => project.id }),
        link_to('Activate', {:controller => "projects", :action => "activate", :project_id => project.id }),
        link_to('Edit', "projects/#{project.id}/edit"),
        link_to('Find use', {:controller => "projects", :action => "find_use", :project_id => project.id }, :remote => true),
        link_to('Destroy', project, confirm: 'Are you sure?', method: :delete)
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