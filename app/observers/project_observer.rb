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

class ProjectObserver < ActiveRecord::Observer
  observe Project

  #def after_create(project)
    #New default wbs
    #wbs = Wbs.new(:project => project)
    #wbs.save

    #New root component
    #component = Component.new(:is_root => true, :wbs_id => wbs.id, :work_element_type_id => default_work_element_type.id, :position => 0, :name => "Root folder")
    #component.save
  #end

  #def before_destroy(project)
    #project.users.each do |user|
    #  user.ten_latest_projects.delete(project.id)
    #  user.save
    #end
  #end

  #private
  #def default_work_element_type
  #  wet = WorkElementType.find_by_alias("folder")
  #  return wet
  #end

end