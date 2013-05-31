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

module WbsActivitiesHelper

  def page_navigation_links(pages, param_name=:page)
    will_paginate(pages, :params => {:anchor => "tabs-4"}, :class => 'pagination', :inner_window => 2, :outer_window => 0, :renderer => BootstrapHelper::LinkRenderer, :previous_label => '&larr;'.html_safe, :next_label => '&rarr;'.html_safe, :param_name => param_name)
  end

end
