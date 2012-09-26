#Some helper for the app...
module ApplicationHelper

  #Alllow to sort the table.
  def sortable(column, title = nil, controller_name = nil)
    title ||= column.titleize
    #direction = column == sort_column &&
    sort_direction == "asc" ? "desc" : "asc"
    link_to title, { :sort => column, :direction => sort_direction, :page => nil }, :method => "get", :remote => true
  end

  def pop_up(id, title, to_container=true, &block)
		ret = content_tag(:div, { :class => "pop_up", :style => "display: none;", :id => id }) do
			res = content_tag(:div, { :class => "pop_up_title_bar"}) do
				content_tag(:h1, title) + link_to_function('X', "hide_popup('#{id}')", :class => "pop_up_close_button")
			end

			res += capture(&block) if block_given?

			res
		end
  end

end
