#encoding: utf-8
##########################################################################
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


module ProjectsHelper
  def build_find_use_project_popup(project_id)
    project = Project.find(project_id)
    pop_up("find_use_project_#{project_id}", "Find use Project #{project_id}") do
      title = content_tag(:p, "Relationships with #{project} :")
      x = content_tag(:li, "Liste des projets associés au projet #{project}")

      ul = content_tag(:ul, title+x)

      ul
    end
  end

  def display_results
    res = String.new
    @module_projects.each do |module_project|
      pemodule = Pemodule.find(module_project.pemodule.id)

      res << "<div class='widget'>"
        res << "<div class='widget-header'>
                  <h3>#{module_project.pemodule.title.humanize}</h3>
                </div>"
        res << "<div class='widget-content'>"
          res << "<table class='table table-bordered'>
                   <tr>
                     <th></th>"
                     current_component.module_project_attributes.each do |mpa|
                       if mpa.output?
                         res << "<th>#{mpa.attribute.name}</th>"
                       end
                     end
                  res << "</tr>"
                  res << "<tr>"
                   ["low", "most_likely", "high"].each do |level|
                      res << "<td>#{level.humanize}</td>"
                      current_component.module_project_attributes.each do |mpa|
                        if mpa.output?
                          res << "<td>#{@results}</td>"
                        end
                      end
                  res << "</tr>"
                      end
          res << "</table>"
        res << "</div>"
      res << "</div>"
    end
    res
  end

  def display_input(module_project_id)
    module_project = ModuleProject.find(module_project_id)
    pemodule = Pemodule.find(module_project.pemodule.id)

    res = String.new

    res << "<div class='widget'>"
      res << "<div class='widget-header'>
                <h3>#{module_project.pemodule.title.humanize} - #{current_component.name}</h3>
              </div>"
      res << "<div class='widget-content'>"

        res << "<table class='table table-bordered'>
                  <tr>
                    <th></th>"
                    current_component.module_project_attributes.each do |mpa|
                      if mpa.input?
                        res << "<th>#{mpa.attribute.name}</th>"
                      end
                    end
                  res << "</tr>"
              ["low", "most_likely", "high"].each do |level|
                res << "<tr>"
                res << "<td>#{level.humanize}</td>"
                current_component.module_project_attributes.each do |mpa|
                  if mpa.input?
                    res << "<td>#{text_field_tag "#{level}[#{mpa.attribute.alias}][#{module_project_id}]"}</td>"
                  end
                end
                res << "</tr>"
              end
        res << "</table>"
      res << "</div>"
    res << "</div>"
  end

end
