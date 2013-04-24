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
      res << "<tr><td>#{estimation_value.pe_attribute.name}</td>"

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
    res <<    "<table class='table table-bordered'>
                 <tr>
                   <th></th>"

    module_project.estimation_values.each do |mpa|
      if (mpa.in_out == "output" or mpa.in_out=="both") and mpa.module_project.id == module_project.id
        res << "<th>#{mpa.pe_attribute.name}</th>"
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
        module_project.estimation_values.where("in_out = ?", "output").each do |est_val|
          if (est_val.in_out == "output" or est_val.in_out=="both") and est_val.module_project.id == module_project.id
            level_estimation_values = Hash.new
            level_estimation_values = est_val.send("string_data_#{level}")
            #puts "ESTIMATION_VALUE = #{est_val}"
            #puts "#{level} LEVEL_ESTIMATION_VALUE = #{level_estimation_values}"
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

  def display_input
    res = String.new
    pbs_project_element = @pbs_project_element || current_project.root_component

    current_project.module_projects.each do |module_project|
      current_project = module_project.project

      if module_project.pemodule.with_activities
        if module_project.pemodule.title == "Effort Breakdown"
          res << display_inputs_without_activities(module_project)
        else
          if module_project.pemodule.alias == "wbs_activity_completion"

            @defined_status = RecordStatus.find_by_name("Defined")

            last_estimation_result = nil
            refer_module = Pemodule.where("alias = ? AND record_status_id = ?", "effort_breakdown", @defined_status.id).first
            refer_attribute = PeAttribute.where("alias = ? AND record_status_id = ?", "effort_man_hour", @defined_status.id).first
            refer_module_project =  current_project.module_projects.where("pemodule_id = ?", refer_module.id).last

            unless refer_module_project.nil?
              last_estimation_results = EstimationValue.where("in_out = ? AND pe_attribute_id = ? AND module_project_id = ?", "output", refer_attribute.id, refer_module_project.id).first
              last_estimation_result = last_estimation_results.nil? ? Hash.new : last_estimation_results
            end
            ###puts "LAST_EFFORT_BREAkDOWN_RESULT = #{last_estimation_results}"
            res << display_inputs_with_activities(module_project, last_estimation_result)
          else
            res << display_inputs_with_activities(module_project)
          end
        end
      else
        res << display_inputs_without_activities(module_project)
      end
    end
    res
  end

  def display_inputs_with_activities(module_project, last_estimation_result=nil)
    pbs_project_element = @pbs_project_element || current_project.root_component
    res = String.new
    if module_project.compatible_with(current_component.work_element_type.alias) || current_component
      pemodule = Pemodule.find(module_project.pemodule.id)
        res << "<div class='widget'>"
          res << "<div class='widget-header'>
                      <h3>#{module_project.pemodule.title.humanize} - #{pbs_project_element.name}</h3>
                  </div>"
          res << "<div class='widget-content'>"
            res << "<table class='table table-bordered'>"
              res << "<tr>
                        <th></th>"
                        ["low", "most_likely", "high"].each do |level|
                          res << "<th>#{level.humanize}</th>"
                        end
                        res << "<th></th>"
              res << "</tr>"

            module_project.project.pe_wbs_projects.wbs_activity.first.wbs_project_elements.each do |wbs_project_elt|
              pe_attribute_alias = nil
              level_parameter = ""
              res << "<tr><td>#{wbs_project_elt.name}</td>"
              ["low", "most_likely", "high"].each do |level|
                res << "<td>"
                module_project.estimation_values.where("in_out = ?", "input").each do |est_val|
                  if (est_val.in_out == "input" and est_val.module_project.id == module_project.id)
                    str = "#{est_val.pe_attribute.attribute_type}_data_#{level}"
                    level_estimation_values = Hash.new
                    level_estimation_values = est_val.send("string_data_#{level}")

                    # For Wbs_Activity Complement module, input data are from last executed module
                    if module_project.pemodule.alias == "wbs_activity_completion"
                      pbs_last_result = nil
                      unless last_estimation_result.nil?
                        level_last_result = last_estimation_result.send("string_data_#{level}")
                        ##puts "LEVEL_RESULT = #{level_last_result}"
                        pbs_last_result =  level_last_result[pbs_project_element.id]
                        ##puts "PBS_RESULT = #{pbs_last_result}"
                      end

                      if pbs_last_result.nil? || wbs_project_elt.wbs_activity_element.nil?
                        res << "#{text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id.to_s}][#{wbs_project_elt.id.to_s}]"}"
                      else
                        res << "#{text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id.to_s}][#{wbs_project_elt.id.to_s}]", pbs_last_result[wbs_project_elt.id], :readonly => true}"
                      end
                    else
                      if level_estimation_values.nil? or level_estimation_values[pbs_project_element.id].nil?
                        res << "#{text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id.to_s}][#{wbs_project_elt.id.to_s}]"}"
                      else
                        res << "#{text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id.to_s}][#{wbs_project_elt.id.to_s}]", level_estimation_values[pbs_project_element.id][wbs_project_elt.id.to_s]}"
                      end
                    end

                  end
                  pe_attribute_alias = est_val.pe_attribute.alias
               end
               res << "</td>"
              end

              #Available to copy value
              input_id = "_#{pe_attribute_alias}_#{module_project.id}_#{wbs_project_elt.id}"
              res << "<td><div id='#{input_id}' class='copyLib' data-effort_input_id='#{input_id}' title='Copy value in other fields'></td></div>"

             res << "</tr>"
           end
          res << "</table>"
        res << "</div>"
      res << "</div>"
    end
    res
  end


  # Display th inputs parameters view
  def display_inputs_without_activities(module_project)
    pbs_project_element = @pbs_project_element || current_project.root_component
    res = String.new
    if module_project.compatible_with(current_component.work_element_type.alias) || current_component
      pemodule = Pemodule.find(module_project.pemodule.id)
          res << "<div class='widget'>"
            res << "<div class='widget-header'>
                      <h3>#{module_project.pemodule.title.humanize} - #{pbs_project_element.name}</h3>
                    </div>"
            res << "<div class='widget-content'>"

              res << "<table class='table table-bordered'>
                        <tr>
                          <th></th>"
                          ###current_component.estimation_values.each do |est_val|
                          module_project.estimation_values.each do |est_val|
                            if (est_val.in_out == "input" or est_val.in_out=="both") and est_val.module_project.id == module_project.id
                              res << "<th>#{est_val.pe_attribute.name}</th>"
                            end
                          end
                        res << "</tr>"
                    ["low", "most_likely", "high"].each do |level|
                      res << "<tr>"
                      res << "<td>#{level.humanize}</td>"
                      module_project.estimation_values.each do |est_val|
                        if (est_val.in_out == "input" or est_val.in_out=="both") and est_val.module_project.id == module_project.id
                          level_estimation_values = Hash.new
                          level_estimation_values = est_val.send("string_data_#{level}")
                          if level_estimation_values[pbs_project_element.id].nil?
                            res << "<td>#{text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id}]", level_estimation_values["default_#{level}"]}</td>"
                          else
                            res << "<td>#{text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id}]", level_estimation_values[pbs_project_element.id]}</td>"
                          end
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

end
