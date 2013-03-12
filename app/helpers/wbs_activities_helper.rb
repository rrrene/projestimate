module WbsActivitiesHelper

  def page_navigation_links(pages, param_name=:page)
    will_paginate(pages, :params => {:anchor => "tabs-4"}, :class => 'pagination', :inner_window => 2, :outer_window => 0, :renderer => BootstrapHelper::LinkRenderer, :previous_label => '&larr;'.html_safe, :next_label => '&rarr;'.html_safe, :param_name => param_name)
  end

end
