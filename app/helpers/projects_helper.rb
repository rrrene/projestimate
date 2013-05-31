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
    unless current_project.nil?
      pbs_project_element = @pbs_project_element || current_project.root_component
      current_project.module_projects.select{|i| i.pbs_project_elements.map(&:id).include?(pbs_project_element.id) }.each do |module_project|
        if module_project.pemodule.yes_for_output_with_ratio? || module_project.pemodule.yes_for_output_without_ratio? || module_project.pemodule.yes_for_input_output_with_ratio? || module_project.pemodule.yes_for_input_output_without_ratio?
          res << display_results_with_activities(module_project)
        else
          res << display_results_without_activities(module_project)
        end
        res
      end
    end
    res
  end


  def display_results_without_activities(module_project)
    res = String.new
    pbs_project_element = @pbs_project_element || current_project.root_component

    pemodule = Pemodule.find(module_project.pemodule.id)
    res << "<h4>#{module_project.pemodule.title.humanize} - #{pbs_project_element.name}</h4>"
    res << "<table class='table table-condensed table-bordered'>
                 <tr>
                   <th></th>"
                    ['low', 'most_likely', 'high', 'probable'].each do |level|
                      res << "<th>#{level.humanize}</th>"
                    end
        res << '</tr>'

    module_project.estimation_values.where('in_out = ?', 'output').each do |estimation_value|
      res << "<tr><td><span class='attribute_tooltip tree_element_in_out' title='#{estimation_value.pe_attribute.description} #{display_rule(estimation_value)}'>#{estimation_value.pe_attribute.name}</span></td>"

      ['low', 'most_likely', 'high', 'probable'].each do |level|
        res << '<td>'
        level_estimation_values = Hash.new
        level_estimation_values = estimation_value.send("string_data_#{level}")
        if level_estimation_values.nil? || level_estimation_values[pbs_project_element.id].nil? || level_estimation_values[pbs_project_element.id].blank?
          res << '-'
        else
          res << "#{pemodule_output(level_estimation_values, pbs_project_element, estimation_value)}"
        end
        res << '</td>'
      end
      res << '</tr>'
    end

    res << '</table>'

    res
  end


  #The view to display result with ACTIVITIES
  def display_results_with_activities(module_project)
    res = String.new
    pbs_project_element = @pbs_project_element || current_project.root_component

    pe_wbs_activity = module_project.project.pe_wbs_projects.wbs_activity.first
    project_wbs_project_elt_root = pe_wbs_activity.wbs_project_elements.elements_root.first

    pemodule = Pemodule.find(module_project.pemodule.id)
    res << " <h4>#{module_project.pemodule.title.humanize} - #{pbs_project_element.name}</h4> "
    res << " <table class='table table-condensed table-bordered'>
               <tr>
                 <th></th>"

    # Get the module_project probable estimation values for showing element consistency
    probable_est_value_for_consistency = nil

    module_project.estimation_values.each do |mpa|
      if (mpa.in_out == 'output' or mpa.in_out=='both') and mpa.module_project.id == module_project.id
        probable_est_value_for_consistency = mpa.send("string_data_probable")
        res << "<th colspan='4'><span class='attribute_tooltip' title='#{mpa.pe_attribute.description} #{display_rule(mpa)}'>#{mpa.pe_attribute.name}</span></th>"
      end
    end
    res << '</tr>'

    # We are showing for each PBS and/or ACTIVITY the (low, most_likely, high) values
    res << '<tr>
              <th></th>'
              ['low', 'most_likely', 'high', 'probable'].each do |level|
                res << "<th>#{level.humanize}</th>"
              end
    res << '</tr>'

    module_project.project.pe_wbs_projects.wbs_activity.first.wbs_project_elements.each do |wbs_project_elt|
      pbs_probable_for_consistency = probable_est_value_for_consistency.nil? ? nil : probable_est_value_for_consistency[pbs_project_element.id]
      wbs_project_elt_consistency = (pbs_probable_for_consistency.nil? || pbs_probable_for_consistency[wbs_project_elt.id].nil?) ? false : pbs_probable_for_consistency[wbs_project_elt.id][:is_consistent]
      show_consistency_class = nil
      unless wbs_project_elt_consistency
        show_consistency_class = "<span class='consistency_class' title='#{wbs_project_elt.name} is not complete : all values (low, most likely and high) must be set correctly'> &#33; </span>"
      end
      res << "<tr>
                <td><span class='tree_element_in_out' style='margin-left:#{wbs_project_elt.depth}em;'> #{show_consistency_class}  #{wbs_project_elt.name}</span></td>"

      ['low', 'most_likely', 'high', 'probable'].each do |level|
        res << '<td>'
        module_project.estimation_values.where('in_out = ?', 'output').each do |est_val|
          if (est_val.in_out == 'output' or est_val.in_out=='both') and est_val.module_project.id == module_project.id
            level_estimation_values = Hash.new
            level_estimation_values = est_val.send("string_data_#{level}")
            #puts "ESTIMATION_VALUE = #{est_val}"
            #puts "#{level} LEVEL_ESTIMATION_VALUE = #{level_estimation_values}"
            if level_estimation_values.nil? || level_estimation_values[pbs_project_element.id].nil? || level_estimation_values[pbs_project_element.id][wbs_project_elt.id].nil? || level_estimation_values[pbs_project_element.id][wbs_project_elt.id][:value].nil?
              res << ' - '
            else
              res << "#{level_estimation_values[pbs_project_element.id][wbs_project_elt.id][:value]}"
              ###TODO res << "#{pemodule_output(level_estimation_values, pbs_project_element, est_val)}"
            end
          end
        end
        res << '</td>'
      end
      res << '</tr>'
    end

    #Show the global result of the PBS
    res << '<tr>
              <td><strong>  </strong></td>'
      ['low', 'most_likely', 'high', 'probable'].each do |level|
        res << '<td></td>'
      end
    res << '</tr>'

    # Show the probable values
    res << "<tr><td><strong> #{pbs_project_element.name} Probable Value </strong> </td>"
    module_project.estimation_values.each do |mpa|
      if (mpa.in_out == 'output' or mpa.in_out=='both') and mpa.module_project.id == module_project.id
        res << "<td colspan='3'>"
        level_probable_value = mpa.send('string_data_probable')
        if level_probable_value.nil? || level_probable_value[pbs_project_element.id].nil? || level_probable_value[pbs_project_element.id][project_wbs_project_elt_root.id].nil? || level_probable_value[pbs_project_element.id][project_wbs_project_elt_root.id][:value].nil?
          res << '-'
        else
          res << "<div align='center'>#{level_probable_value[pbs_project_element.id][project_wbs_project_elt_root.id][:value]}</div>"
        end
        res << '</td>'
        res << '<td></td>'
      end
    end
    res << '</tr>'
    res << '</table>'

    res
  end


  # Display Estimations output results according to the module behavior
  def display_input
    res = String.new
    unless current_project.nil?
      pbs_project_element = @pbs_project_element || current_project.root_component

      current_project.module_projects.select{|i| i.pbs_project_elements.map(&:id).include?(pbs_project_element.id) }.each do |module_project|
        current_project = module_project.project

        ##if module_project.pemodule.with_activities
        if module_project.pemodule.yes_for_input? || module_project.pemodule.yes_for_input_output_without_ratio? || module_project.pemodule.yes_for_input_output_with_ratio?

          if module_project.pemodule.alias == "wbs_activity_completion"
            @defined_status = RecordStatus.find_by_name("Defined")
            last_estimation_result = nil
            effort_breakdown_module = Pemodule.where("alias = ? AND record_status_id = ?", "effort_breakdown", @defined_status.id).first

            unless effort_breakdown_module.nil?
              refer_module_potential_ids = module_project.associated_module_projects + module_project.inverse_associated_module_projects
              #unless refer_module.empty?
                refer_attribute = PeAttribute.where("alias = ? AND record_status_id = ?", "effort_man_hour", @defined_status.id).first
                refer_modules_project =  ModuleProject.joins(:project, :pbs_project_elements).where("pemodule_id = ? AND  project_id =? AND pbs_project_elements.id = ?", effort_breakdown_module.id, current_project.id, pbs_project_element.id)
                refer_module_project = refer_modules_project.where(["module_project_id IN (?)", refer_module_potential_ids]).last
                unless refer_module_project.nil?
                  last_estimation_results = EstimationValue.where('in_out = ? AND pe_attribute_id = ? AND module_project_id = ?', 'output', refer_attribute.id, refer_module_project.id).first
                  if last_estimation_results.nil?
                    last_estimation_result = Hash.new
                  else
                    pe_wbs_project_activity = current_project.pe_wbs_projects.wbs_activity.first
                    project_wbs_root = pe_wbs_project_activity.wbs_project_elements.where("is_added_wbs_root = ?", true).first

                    # Get all complement children
                    complement_children = get_all_complement_children
                    current_mp_est_value = module_project.estimation_values.where("pe_attribute_id = ? AND in_out = ?", refer_attribute.id, "output").last
                    ['low', 'most_likely', 'high'].each do |level|
                      level_effort_breakdown_est_val =  last_estimation_result.send("string_data_#{level}")
                      level_current_mp_est_val = current_mp_est_value.send("string_data_#{level}")
                      if !level_current_mp_est_val.nil? || !level_current_mp_est_val.empty?
                        pbs_level_value = level_current_mp_est_val[pbs_project_element.id]
                        #if pbs_level_value.nil?
                      else

                      end
                    end
                    last_estimation_result = last_estimation_results
                  end
                end
              #end
            end
            res << display_inputs_with_activities(module_project, last_estimation_result)
            # For Effort balancing module
          elsif module_project.pemodule.alias == 'effort_balancing'
            res << display_effort_balancing(module_project, last_estimation_result)
            # For others module with Activities
          else
            res << display_inputs_with_activities(module_project)
          end
          # For others modules that don't use WSB-Activities values in input
        elsif module_project.pemodule.no? || module_project.pemodule.no? || module_project.pemodule.yes_for_output_with_ratio? || module_project.pemodule.yes_for_output_without_ratio?
          res << display_inputs_without_activities(module_project)
        end
      end
    end
    res
  end

  def display_effort_balancing(module_project, last_estimation_result)
    pbs_project_element = @pbs_project_element || current_project.root_component
    res = String.new
    if module_project.compatible_with(current_component.work_element_type.alias) || current_component
      pemodule = Pemodule.find(module_project.pemodule.id)
      res << "<h4>#{module_project.pemodule.title.humanize} - #{pbs_project_element.name}</h4>"
      res << "<table class='table table-condensed table-bordered'>"

      res << '<tr>
                <th></th>'
        module_project.previous.each_with_index do |est,i|
          res << "<th>Estimation - #{i}</th>"
        end
        module_project.estimation_values.each do |est_val|
          if (est_val.in_out == 'input' or est_val.in_out=='both') and est_val.module_project.id == module_project.id
            res << "<th><span class='attribute_tooltip' title='#{est_val.pe_attribute.description} #{display_rule(est_val)}' rel='tooltip'>#{est_val.pe_attribute.name}</span></th>"
          end
        end

      res << '</tr>'

        module_project.project.pe_wbs_projects.wbs_activity.first.wbs_project_elements.each do |wbs_project_elt|
          res << "<tr>
                    <td>
                      <span class='tree_element_in_out' style='margin-left:#{wbs_project_elt.depth}em;'>#{wbs_project_elt.name}</span></td>"
          res << '</td>'
          module_project.previous.each do |mp|

            mp.estimation_values.select{|i| i.in_out == 'output'}.each do |est_val|
              level_estimation_values = Hash.new
              level_estimation_values = est_val.send("string_data_probable")

                res << '<td>'
                  if level_estimation_values
                    res << text_field_tag("", level_estimation_values[pbs_project_element.id][wbs_project_elt.id][:value] , :readonly => true, :class => "input-small #{est_val.id}")
                  end
                res << '</td>'
              end
          end

          module_project.estimation_values.select{|i| i.in_out == 'input'}.each do |est_val|
            res << '<td>'
            res << "#{text_field_tag "[#{est_val.pe_attribute.alias.to_sym}][#{module_project.id.to_s}][#{wbs_project_elt.id.to_s}]", '', :class => "input-small #{est_val.id}"}"
            res << '</td>'
          end

          res << '</tr>'
        end
      res << '</table>'
    end

  end

  def display_inputs_with_activities(module_project, last_estimation_result=nil)
    pbs_project_element = @pbs_project_element || current_project.root_component
    res = String.new
    if module_project.compatible_with(current_component.work_element_type.alias) || current_component
      pemodule = Pemodule.find(module_project.pemodule.id)
      res << "<h4>#{module_project.pemodule.title.humanize} - #{pbs_project_element.name}</h4>"
      res << "<table class='table table-condensed table-bordered'>"
      res << '<tr>
                <th></th>'
      module_project.estimation_values.each do |mpa|
        if (mpa.in_out == 'output' or mpa.in_out=='both') and mpa.module_project.id == module_project.id
          res << "<th colspan=4><span class='attribute_tooltip' title='#{mpa.pe_attribute.description} #{display_rule(mpa)}' rel='tooltip'>#{mpa.pe_attribute.name}</span></th>"
        end
      end
      res << '</tr>'

      res << '<tr>
                <th></th>'
                ['low', '', 'most_likely', 'high'].each do |level|
                  res << "<th>#{level.humanize}</th>"
                end
      res << '</tr>'

      module_project.project.pe_wbs_projects.wbs_activity.first.wbs_project_elements.each do |wbs_project_elt|
        pe_attribute_alias = nil
        level_parameter = ''
        readonly_option = false
        res << "<tr><td><span class='tree_element_in_out' style='margin-left:#{wbs_project_elt.depth}em;'>#{wbs_project_elt.name}</span></td>" ###res << "<tr><td>#{wbs_project_elt.name}</td>"

        ['low', 'most_likely', 'high'].each do |level|
          res << '<td>'
          module_project.estimation_values.where('in_out = ?', 'input').each do |est_val|
            if (est_val.in_out == 'input' and est_val.module_project.id == module_project.id)
              str = "#{est_val.pe_attribute.attribute_type}_data_#{level}"
              level_estimation_values = Hash.new
              level_estimation_values = est_val.send("string_data_#{level}")

              # For Wbs_Activity Complement module, input data are from last executed module
              if module_project.pemodule.alias == 'wbs_activity_completion'
                pbs_last_result = nil
                unless last_estimation_result.nil?
                  level_last_result = last_estimation_result.send("string_data_#{level}")
                  ##puts "LEVEL_RESULT = #{level_last_result}"
                  pbs_last_result =  level_last_result[pbs_project_element.id]
                  ##puts "PBS_RESULT = #{pbs_last_result}"
                end

                if pbs_last_result.nil?
                  res << "#{text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id.to_s}][#{wbs_project_elt.id.to_s}]", nil, :class => "input-small  #{level} #{est_val.id}"}"

                elsif wbs_project_elt.wbs_activity_element.nil?
                  if wbs_project_elt.is_root? || wbs_project_elt.has_children?
                    res << "#{text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id.to_s}][#{wbs_project_elt.id.to_s}]", pbs_last_result[wbs_project_elt.id][:value], :readonly => true, :class => "input-small  #{level} #{est_val.id}"}"
                    readonly_option = true
                  else
                    res << "#{text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id.to_s}][#{wbs_project_elt.id.to_s}]", nil, :class => "input-small  #{level} #{est_val.id}"}"
                  end
                else
                  res << "#{text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id.to_s}][#{wbs_project_elt.id.to_s}]", pbs_last_result[wbs_project_elt.id][:value], :readonly => true, :class => "input-small #{level} #{est_val.id}"}"
                  readonly_option = true
                end
              else
                readonly_option = wbs_project_elt.has_children? ? true : false
                nullity_condition = (level_estimation_values.nil? or level_estimation_values[pbs_project_element.id].nil? or level_estimation_values[pbs_project_element.id][wbs_project_elt.id].nil?)
                if wbs_project_elt.is_root? || wbs_project_elt.has_children?
                  res << "#{ text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id.to_s}][#{wbs_project_elt.id.to_s}]", nullity_condition ?  nil : level_estimation_values[pbs_project_element.id][wbs_project_elt.id], :readonly => readonly_option, :class => 'input-small' }"
                else
                  res << "#{ text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id.to_s}][#{wbs_project_elt.id.to_s}]", nullity_condition ?  level_estimation_values["default_#{level}".to_sym] : level_estimation_values[pbs_project_element.id][wbs_project_elt.id], :readonly => readonly_option, :class => 'input-small' }"
                end
               end

            end
            pe_attribute_alias = est_val.pe_attribute.alias
          end
          res << '</td>'

          if level == 'low'
            #Available to copy value
            input_id = "_#{pe_attribute_alias}_#{module_project.id}_#{wbs_project_elt.id}"
            res << '<td>'
            unless readonly_option
              res << "<span id='#{input_id}' class='copyLib icon  icon-chevron-right' data-effort_input_id='#{input_id}' title='Copy value in other fields' onblur='this.style.cursor='default''></span>"
            end
            res << '</td>'
          end
        end
       res << '</tr>'
     end
        res << '</table>'
      end
    res
  end


  # Display th inputs parameters view
  def display_inputs_without_activities(module_project)
    pbs_project_element = @pbs_project_element || current_project.root_component
    res = String.new
    if module_project.compatible_with(current_component.work_element_type.alias) || current_component
      pemodule = Pemodule.find(module_project.pemodule.id)
        res << "<h4>#{module_project.pemodule.title.humanize} - #{pbs_project_element.name}</h4>"
          res << "<table class='table table-condensed table-bordered'>
                      <tr>
                        <th></th>"
                        ['low', '', 'most_likely', 'high'].each do |level|
                          res << "<th>#{level.humanize}</th>"
                        end
                      res << '</tr>'
            module_project.estimation_values.each do |est_val|
              if (est_val.in_out == 'input' or est_val.in_out=='both') and est_val.module_project.id == module_project.id
                res << '<tr>'
                res << "<td><span class='attribute_tooltip tree_element_in_out' title='#{est_val.pe_attribute.description} #{display_rule(est_val)}'>#{est_val.pe_attribute.name}</span></td>"
                level_estimation_values = Hash.new
                ['low', 'most_likely', 'high'].each do |level|
                level_estimation_values = est_val.send("string_data_#{level}")
                  res << "<td>#{pemodule_input(level, est_val, module_project, level_estimation_values, pbs_project_element)}</td>"
                  if level == 'low'
                    input_id = "_#{est_val.pe_attribute.alias}_#{module_project.id}"
                    res << '<td>'
                      res << "<span id='#{input_id}' class='copyLib icon  icon-chevron-right' data-effort_input_id='#{input_id}' title='Copy value in other fields' onblur='this.style.cursor='default''></span>"
                    res << '</td>'
                  end
                end
              end
              res << '</tr>'
            end
          res << '</table>'
      end
    res
  end

  def pemodule_input(level, est_val, module_project, level_estimation_values, pbs_project_element)
    if est_val.pe_attribute.attr_type == 'integer' or est_val.pe_attribute.attr_type == 'float'

      display_text_field_tag(level, est_val, module_project, level_estimation_values, pbs_project_element)

    elsif est_val.pe_attribute.attr_type == 'list'

      select_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id}]",
                 options_for_select(
                     est_val.pe_attribute.options[2].split(';'),
                     :selected => (level_estimation_values[pbs_project_element.id].nil? ? level_estimation_values["default_#{level}".to_sym] : level_estimation_values[pbs_project_element.id])),
                     :class => 'input-small',
                     :prompt => "Unset"

    elsif est_val.pe_attribute.attr_type == 'date'

      text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id}]",
                      level_estimation_values[pbs_project_element.id].nil? ? display_date(level_estimation_values["default_#{level}".to_sym]) : display_date(level_estimation_values[pbs_project_element.id]),
                     :class => "input-small #{level} #{est_val.id} date-picker"

    else #type = text

      text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id}]",
                     (level_estimation_values[pbs_project_element.id].nil?) ? level_estimation_values["default_#{level}".to_sym] : level_estimation_values[pbs_project_element.id],
                     :class => "input-small #{level} #{est_val.id}"
    end
  end

  #Display pemodule output depending attribute type.
  def pemodule_output(level_estimation_values, pbs_project_element, estimation_value)
    if estimation_value.pe_attribute.attr_type == 'date'
      display_date(level_estimation_values[pbs_project_element.id])
    elsif estimation_value.pe_attribute.attr_type == 'float'
      begin
        if estimation_value.pe_attribute.precision
          level_estimation_values[pbs_project_element.id].round(estimation_value.pe_attribute.precision)
        else
          level_estimation_values[pbs_project_element.id].round(2)
        end
      rescue
        level_estimation_values[pbs_project_element.id]
      end
    else
      level_estimation_values[pbs_project_element.id]
    end
  end

  #Display a date depending user time zone
  def display_date(date)
    begin
      I18n.l(date.to_date)
    rescue
      nil
    end
  end

  #Display text field tag depending of estimation plan.
  #Some pemodules can take previous and computed values
  def display_text_field_tag(level, est_val, module_project, level_estimation_values, pbs_project_element)
    unless module_project.previous.empty?
      comm_attr = ModuleProject::common_attributes(module_project.previous.first, module_project)
      if comm_attr.empty?
        text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id}]",
                       level_estimation_values[pbs_project_element.id].nil? ? level_estimation_values["default_#{level}".to_sym] : level_estimation_values[pbs_project_element.id],
                       :class => "input-small #{level} #{est_val.id}"
      else
        estimation_value = EstimationValue.where(:pe_attribute_id => comm_attr.first.id, :module_project_id => module_project.previous.first.id).first
        new_level_estimation_values = estimation_value.send("string_data_#{level}")
        text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id}]",
                       new_level_estimation_values[pbs_project_element.id],
                       :class => "input-small #{level} #{est_val.id}"
      end
    else
      text_field_tag "[#{level}][#{est_val.pe_attribute.alias.to_sym}][#{module_project.id}]",
                     level_estimation_values[pbs_project_element.id].nil? ? level_estimation_values["default_#{level}".to_sym] : level_estimation_values[pbs_project_element.id],
                     :class => "input-small #{level} #{est_val.id}"
    end
  end

  #Display rule and options of an attribute in a bootstrap tooltip
  def display_rule(est_val)
    "<br> #{I18n.t(:tooltip_attribute_rules)}: <strong>#{est_val.pe_attribute.options.join(' ')} </strong> <br> #{est_val.is_mandatory ? I18n.t(:mandatory) : I18n.t(:no_mandatory) }"
  end

end
