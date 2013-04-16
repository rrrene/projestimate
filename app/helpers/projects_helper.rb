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

  # This helper method will display Estimation Result according the estimation purpose (PBS and/or Activities)
  def display_results
    res = String.new
    pbs_project_element = @pbs_project_element || current_project.root_component
    current_project.module_projects.each do |module_project|
      if module_project.pemodule.with_activities
        res << display_results_with_activities(module_project)
      else
        res << display_results_without_activities(module_project)
      end
      res
    end
    res
  end



  def display_results_without_activities(module_project)
    res = String.new
    pbs_project_element = @pbs_project_element || current_project.root_component
    ##@module_projects.each do |module_project|
      pemodule = Pemodule.find(module_project.pemodule.id)
      res << "<div class='widget'>"
      res << "<div class='widget-header'>
                  <h3>#{module_project.pemodule.title.humanize} - #{pbs_project_element.name}</h3>
                </div>"
      res << "<div class='widget-content'>"
      res << "<table class='table table-bordered'>
                   <tr>
                     <th></th>"
      ["low", "most_likely", "high", "probable"].each do |level|
        res << "<th>#{level.humanize}</th>"
      end
      res << "</tr>"

      module_project.estimation_values.where("in_out = ?", "output").each do |estimation_value|
        res << "<tr><td>#{estimation_value.attribute.name}</td>"

        ["low", "most_likely", "high", "probable"].each do |level|
          res << "<td>"
          level_estimation_value = Hash.new
          level_estimation_value = estimation_value.send("string_data_#{level}")
          if level_estimation_value.nil? || level_estimation_value[pbs_project_element.id].nil?
            res << "-"
          else
            res << "#{level_estimation_value[pbs_project_element.id]}"
          end
          res << "</td>"
        end
        res << "</tr>"
      end

      res << "</table>"
      res << "</div>"
      res << "</div>"
    #end
    res
  end


  #The view to display result with ACTIVITIES
  def display_results_with_activities(module_project)
    res = String.new
    pbs_project_element = @pbs_project_element || current_project.root_component

    pe_wbs_activity = module_project.project.pe_wbs_projects.wbs_activity.first
    project_wbs_project_elt_root = pe_wbs_activity.wbs_project_elements.elements_root.first

    pemodule = Pemodule.find(module_project.pemodule.id)
    res << "<div class='widget'>"
    res << "<div class='widget-header'>
                <h3>#{module_project.pemodule.title.humanize} - #{pbs_project_element.name}</h3>
              </div>"
    res << "<div class='widget-content'>"
    res << "<table class='table table-bordered'>
                 <tr>
                   <th></th>"

    module_project.estimation_values.each do |mpa|
      if (mpa.in_out == "output" or mpa.in_out=="both") and mpa.module_project.id == module_project.id
        res << "<th>#{mpa.attribute.name}</th>"
      end
    end
    res << "</tr>"

    # We are showing for each PBS and/or ACTIVITY the (low, most_likely, high) values
    res << "<tr>
              <th></th>"
              ["low", "most_likely", "high", "probable"].each do |level|
                res << "<th>#{level.humanize}</th>"
              end
    res << "</tr>"

    module_project.project.pe_wbs_projects.wbs_activity.first.wbs_project_elements.each do |wbs_project_elt|
      res << "<tr>
                <td>#{wbs_project_elt.name}</td>"

      ["low", "most_likely", "high", "probable"].each do |level|
        res << "<td>"
        module_project.estimation_values.where("in_out = ?", "output").each do |mpa|
          if (mpa.in_out == "output" or mpa.in_out=="both") and mpa.module_project.id == module_project.id
            str = "#{mpa.attribute.attribute_type}_data_#{level}"
            level_estimation_values = Hash.new
            level_estimation_values = mpa.send("string_data_#{level}")
            if level_estimation_values.nil? || level_estimation_values[pbs_project_element.id].nil?
              res << " - "
            else
              res << "#{level_estimation_values[pbs_project_element.id][wbs_project_elt.id]}"
            end
          end
        end
        res << "</td>"
      end
      res << "</tr>"
    end

    #Show the global result of the PBS
    res << "<tr>
              <td><strong>  </strong></td>"
    ["low", "most_likely", "high", "probable"].each do |level|
      res << "<td></td>"
    end
    res << "</tr>"

    # Show the probable values
    res << "<tr><td><strong> #{pbs_project_element.name} Probable Value </strong> </td>"
    module_project.estimation_values.each do |mpa|
      if (mpa.in_out == "output" or mpa.in_out=="both") and mpa.module_project.id == module_project.id
        res << "<td colspan='3'>"

        str = "#{mpa.attribute.attribute_type}_data_probable"
        level_probable_value = mpa.send("string_data_probable")
        if level_probable_value.nil? || level_probable_value[pbs_project_element.id].nil?
          res << "-"
        else
          res << "<div align='center'>#{level_probable_value[pbs_project_element.id][project_wbs_project_elt_root.id]}</div>"
        end
        res << "</td>"
        res << "<td></td>"
      end
    end
    res << "</tr>"
    res << "</table>"
    res << "</div>"
    res << "</div>"

    res
  end


  # Display th inputs parameters view
  def display_input
    res = String.new
    @module_projects.each do |module_project|
      if module_project.compatible_with(current_component.work_element_type.alias) || current_component
        pemodule = Pemodule.find(module_project.pemodule.id)
          res << "<div class='input_data'>"
            res << "<div class='widget'>"
              res << "<div class='widget-header'>
                        <h3>#{module_project.pemodule.title.humanize} - #{current_component.name}</h3>
                      </div>"
              res << "<div class='widget-content'>"

                res << "<table class='table table-bordered'>
                          <tr>
                            <th></th>"
                            ###current_component.estimation_values.each do |mpa|
                            module_project.estimation_values.each do |mpa|
                              if (mpa.in_out == "input" or mpa.in_out=="both") and mpa.module_project.id == module_project.id
                                res << "<th>#{mpa.attribute.name}</th>"
                              end
                            end
                          res << "</tr>"
                      ["low", "most_likely", "high"].each do |level|
                        res << "<tr>"
                        res << "<td>#{level.humanize}</td>"
                        ###current_component.estimation_values.each do |mpa|
                        module_project.estimation_values.each do |mpa|
                          if (mpa.in_out == "input" or mpa.in_out=="both") and mpa.module_project.id == module_project.id
                            res << "<td>#{text_field_tag "#{level}[#{mpa.attribute.alias}][#{module_project.id}]", mpa.send("#{mpa.attribute.attribute_type}_data_#{level}")}</td>"
                          end
                        end
                        res << "</tr>"
                      end
                res << "</table>"
              res << "</div>"
            res << "</div>"
        end
      end
    res
  end

  def display_charts_results
    array = ['Heavy Industry', 12],['Retail', 9], ['Light Industry', 14], ['Out of home', 16],['Commuting', 7], ['Orientation', 9]
  end

end
