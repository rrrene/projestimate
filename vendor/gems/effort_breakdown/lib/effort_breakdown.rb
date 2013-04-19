require 'effort_breakdown/version'

module EffortBreakdown

  #Effort Breakdown class
  class EffortBreakdown
    attr_accessor  :pbs_project_element, :module_project, :input_effort_man_hour #module input/output parameters

    def initialize(module_input_data)
      @pbs_project_element = PbsProjectElement.find(module_input_data[:pbs_project_element_id])
      @module_project = ModuleProject.find(module_input_data[:module_project_id])
      @input_effort_man_hour = module_input_data[:effort_man_hour].to_f
    end

    #def effort_man_hour(pbs_project_element)
    #  #TODO i think that elem[:input_effort_man_hour] id from the "Estimation_Value" table (need to know the "module_project_id")
    #  # Also need to know which value from (min, max, most_likely, probable) will be used when running this estimation module
    #  @input_effort_man_hour = pbs_project_element[:input_effort_man_hour]
    #end


    # Getters for module outputs

    # return effort for each Wbs-Activity-Element
    def get_leaf_activity_element_effort(wbs_activity_element)

    end

    # Return effort for each Wbs-Activity node, using aggregation (sum of its element effort)
    def get_node_wbs_activity_element_effort(wbs_activity_element)

    end

    # Return effort of associated Pbs-Element
    def get_pbs_effort_man_hour(pbs_elem)

    end

    # Calculate each Wbs activity effort according to Ratio and Reference_Value
    def get_effort_man_hour

      # First build cache_depth
      WbsProjectElement.rebuild_depth_cache!

      case @module_project.reference_value.value.to_s
        # One Activity-element. defined as the reference
        when 'One Activity-element'
          get_efforts_with_one_activity_element

        # A set of Activity-elements defined as reference
        when 'A set of activity-elements'
          get_efforts_with_a_set_of_activity_elements

        # All Activity-elements defined as reference
        when 'All Activity-elements'
          get_efforts_with_all_activities_elements
        else
          get_efforts_with_one_activity_element
      end
    end


    # Get each wbs-activity-element effort with one activity element as reference
    def get_efforts_with_one_activity_element

      #project on which estimation is
      project = @module_project.project

      # Project pe_wbs_activity
      pe_wbs_activity = @module_project.project.pe_wbs_projects.wbs_activity.first

      # Get the wbs_project_element which contain the wbs_activity_ratio
      project_wbs_project_elt_root = pe_wbs_activity.wbs_project_elements.elements_root.first
      #wbs_project_elt_with_ratio = WbsProjectElement.where("pe_wbs_project_id = ? and wbs_activity_id = ? and is_added_wbs_root = ?", pe_wbs_activity.id, @pbs_project_element.wbs_activity_id, true).first
      # If we manage more than one wbs_activity per project, this will be depend on the wbs_project_element ancestry(witch has the wbs_activity_ratio)
      wbs_project_elt_with_ratio = project_wbs_project_elt_root.children.where('is_added_wbs_root = ?', true).first

      ratio_reference = nil
      # Use project default Ratio, unless PSB got its own Ratio,
      # If default ratio was defined in PBS, it will override the one defined in module-project
      if @pbs_project_element.wbs_activity_ratio.nil?
        ratio_reference = wbs_project_elt_with_ratio.wbs_activity_ratio
      else
        ratio_reference = @pbs_project_element.wbs_activity_ratio
      end

      # Get the referenced wbs_activity_elt of the ratio_reference
      referenced_ratio_element = WbsActivityRatioElement.where('wbs_activity_ratio_id =? and simple_reference = ?', ratio_reference.id, true).first

      # Get the WBS-Project element corresponding to the defined activity as the one reference value
      one_activity_element = referenced_ratio_element.wbs_activity_element
      project_one_activity_element = pe_wbs_activity.wbs_project_elements.where('wbs_activity_element_id = ?', one_activity_element.id).first
      puts "ONE_ACTIVITY_ELEMENT_ID = #{one_activity_element.id}"
      puts "project_one_activity_element = #{project_one_activity_element.id}"

      output_effort = Hash.new

      project_wbs_project_elt_root.children.each do |node|
        # Sort node subtree by ancestry_depth
        sorted_node_elements = node.subtree.order('ancestry_depth desc')
        sorted_node_elements.each do |wbs_project_element|
          # A Wbs_project_element is only computed is this module if it has a corresponding Ratio table
          unless wbs_project_element.wbs_activity_element.nil?
            puts "WBS_ACTIVITY_ELEMENT_ID = #{wbs_project_element.id}"

            # Element effort is really computed only on leaf element
            if wbs_project_element.is_childless?
              # Get the ratio Value of current element
              corresponding_ratio_value = WbsActivityRatioElement.where('wbs_activity_ratio_id = ? and wbs_activity_element_id = ?', ratio_reference.id, wbs_project_element.wbs_activity_element_id).first.ratio_value
              current_output_effort = (@input_effort_man_hour.to_f * corresponding_ratio_value.to_f / 100) * referenced_ratio_element.ratio_value.to_f
              puts "OUTPUT_EFFORT #{wbs_project_element.id} = #{current_output_effort}"
              output_effort[wbs_project_element.id] = current_output_effort
            else
              node_effort = 0
              wbs_project_element.children.each do |child|
                unless child.wbs_activity_element.nil? || child.wbs_activity.nil?
                  node_effort = node_effort + output_effort[child.id]
                end
              end
              output_effort[wbs_project_element.id] = node_effort
              puts "NEW_NODE_EFFORT = #{node_effort}"
            end
          end
        end
      end

      # Update the one activity element effort
      output_effort[project_one_activity_element.id] = @input_effort_man_hour

      # After treating all leaf and node elements, the root element is going to compute by aggregation
      #output_effort[project_wbs_project_elt_root.id] = output_effort.inject(0) {|sum, (key,value)| sum += value}
      root_element_effort_man_hour = 0.0
      project_wbs_project_elt_root.children.each do |child|
        unless child.wbs_activity_element.nil? || child.wbs_activity.nil?
          root_element_effort_man_hour = root_element_effort_man_hour + output_effort[child.id]
        end
      end
      output_effort[project_wbs_project_elt_root.id] = root_element_effort_man_hour

      puts "OUTPUT_EFFORT = #{output_effort}"
      pbs_output_effort = Hash.new
      pbs_output_effort["#{@pbs_project_element.id}"] = output_effort
      puts "PBS_OUTPUT_EFFORT = #{pbs_output_effort}"
      #pbs_output_effort
      output_effort
    end

    # Get each wbs-activity-element effort with a set of activity elements as references
    def get_efforts_with_a_set_of_activity_elements

      #project on which estimation is
      project = @module_project.project

      # Project pe_wbs_activity
      pe_wbs_activity = @module_project.project.pe_wbs_projects.wbs_activity.first

      # Get the wbs_project_element which contain the wbs_activity_ratio
      project_wbs_project_elt_root = pe_wbs_activity.wbs_project_elements.elements_root.first
      #wbs_project_elt_with_ratio = WbsProjectElement.where("pe_wbs_project_id = ? and wbs_activity_id = ? and is_added_wbs_root = ?", pe_wbs_activity.id, @pbs_project_element.wbs_activity_id, true).first
      # If we manage more than one wbs_activity per project, this will be depend on the wbs_project_element ancestry(witch has the wbs_activity_ratio)
      wbs_project_elt_with_ratio = project_wbs_project_elt_root.children.where('is_added_wbs_root = ?', true).first

      ratio_reference = nil
      # Use project default Ratio, unless PSB got its own Ratio,
      # If default ratio was defined in PBS, it will override the one defined in module-project
      if @pbs_project_element.wbs_activity_ratio.nil?
        ratio_reference = wbs_project_elt_with_ratio.wbs_activity_ratio
      else
        ratio_reference = @pbs_project_element.wbs_activity_ratio
      end

      #Get the referenced wbs_activity_elt of the ratio_reference
      referenced_ratio_elements = WbsActivityRatioElement.where('wbs_activity_ratio_id =? and multiple_references = ?', ratio_reference.id, true)
      referenced_values_efforts = 0
      referenced_ratio_elements.each do |reference_value|
        referenced_values_efforts = referenced_values_efforts + reference_value.ratio_value.to_f
      end

      output_effort = Hash.new
      project_wbs_project_elt_root.children.each do |node|
        # Sort node subtree by ancestry_depth
        sorted_node_elements = node.subtree.order('ancestry_depth desc')
        sorted_node_elements.each do |wbs_project_element|
          # A Wbs_project_element is only computed is this module if it has a corresponding Ratio table
          unless wbs_project_element.wbs_activity_element.nil?
            puts "WBS_ACTIVITY_ELEMENT_ID = #{wbs_project_element.id}"

            # Element effort is really computed only on leaf element
            if wbs_project_element.is_childless?
              # Get the ratio Value of current element
              corresponding_ratio_value = WbsActivityRatioElement.where('wbs_activity_ratio_id = ? and wbs_activity_element_id = ?', ratio_reference.id, wbs_project_element.wbs_activity_element_id).first.ratio_value
              current_output_effort = (@input_effort_man_hour.to_f * corresponding_ratio_value.to_f / referenced_values_efforts)
              puts "OUTPUT_EFFORT #{wbs_project_element.id} = #{current_output_effort}"
              output_effort[wbs_project_element.id] = current_output_effort
            else
              node_effort = 0
              wbs_project_element.children.each do |child|
                unless child.wbs_activity_element.nil? || child.wbs_activity.nil?
                  node_effort = node_effort + output_effort[child.id]
                end
              end
              output_effort[wbs_project_element.id] = node_effort
              puts "NEW_NODE_EFFORT = #{node_effort}"
            end
          end
        end
      end

      # After treating all leaf and node elements, the root element is going to compute by aggregation
      root_element_effort_man_hour = 0.0
      project_wbs_project_elt_root.children.each do |child|
        unless child.wbs_activity_element.nil? || child.wbs_activity.nil?
          root_element_effort_man_hour = root_element_effort_man_hour + output_effort[child.id]
        end
      end
      output_effort[project_wbs_project_elt_root.id] = root_element_effort_man_hour
      puts "OUTPUT_EFFORT = #{output_effort}"
      #pbs_output_effort
      output_effort
    end


    # Get each wbs-activity-element effort with all activity elements as references
    def get_efforts_with_all_activities_elements

      #project on which estimation is
      project = @module_project.project

      # Project pe_wbs_activity
      pe_wbs_activity = @module_project.project.pe_wbs_projects.wbs_activity.first

      # Get the wbs_project_element which contain the wbs_activity_ratio
      project_wbs_project_elt_root = pe_wbs_activity.wbs_project_elements.elements_root.first
      # wbs_project_elt_with_ratio = WbsProjectElement.where("pe_wbs_project_id = ? and wbs_activity_id = ? and is_added_wbs_root = ?", pe_wbs_activity.id, @pbs_project_element.wbs_activity_id, true).first
      # If we manage more than one wbs_activity per project, this will be depend on the wbs_project_element ancestry(witch has the wbs_activity_ratio)
      wbs_project_elt_with_ratio = project_wbs_project_elt_root.children.where('is_added_wbs_root = ?', true).first

      ratio_reference = nil
      # Use project default Ratio, unless PSB got its own Ratio,
      # If default ratio was defined in PBS, it will override the one defined in module-project
      if @pbs_project_element.wbs_activity_ratio.nil?
        ratio_reference = wbs_project_elt_with_ratio.wbs_activity_ratio
      else
        ratio_reference = @pbs_project_element.wbs_activity_ratio
      end

      output_effort = Hash.new
      project_wbs_project_elt_root.children.each do |node|
        # Sort node subtree by ancestry_depth
        sorted_node_elements = node.subtree.order('ancestry_depth desc')

        sorted_node_elements.each do |wbs_project_element|
          # A Wbs_project_element is only computed is this module if it has a corresponding Ratio table
          unless wbs_project_element.wbs_activity_element.nil?
            puts "WBS_ACTIVITY_ELEMENT_ID = #{wbs_project_element.id}"

            # Element effort is really computed only on leaf element
            if wbs_project_element.is_childless?
              # Get the ratio Value of current element
              corresponding_ratio_value = WbsActivityRatioElement.where('wbs_activity_ratio_id = ? and wbs_activity_element_id = ?', ratio_reference.id, wbs_project_element.wbs_activity_element_id).first.ratio_value
              current_output_effort = (@input_effort_man_hour.to_f * corresponding_ratio_value.to_f / 100)
              puts "OUTPUT_EFFORT #{wbs_project_element.id} = #{current_output_effort}"
              output_effort[wbs_project_element.id] = current_output_effort
            else
              node_effort = 0
              wbs_project_element.children.each do |child|
                unless child.wbs_activity_element.nil? || child.wbs_activity.nil?
                  node_effort = node_effort + output_effort[child.id]
                end
              end
              output_effort[wbs_project_element.id] = node_effort
              puts "NEW_NODE_EFFORT = #{node_effort}"
            end
          end
        end
      end

      # After treating all leaf and node elements, the root element is going to compute by aggregation
      root_element_effort_man_hour = 0.0
      project_wbs_project_elt_root.children.each do |child|
        unless child.wbs_activity_element.nil? || child.wbs_activity.nil?
          root_element_effort_man_hour = root_element_effort_man_hour + output_effort[child.id]
        end
      end
      output_effort[project_wbs_project_elt_root.id] = root_element_effort_man_hour
      output_effort
    end

  end
end
