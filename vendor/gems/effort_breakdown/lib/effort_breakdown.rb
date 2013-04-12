require "effort_breakdown/version"

module EffortBreakdown

  #Effort Breakdown class
  class EffortBreakdown
    attr_accessor  :pbs_project_element, :module_project, :input_effort_per_hour #module input/output parameters

    def initialize(module_input_data)
      @pbs_project_element = PbsProjectElement.find(module_input_data[:pbs_project_element_id])
      @module_project = ModuleProject.find(module_input_data[:module_project_id])
      @input_effort_per_hour = module_input_data[:effort_per_hour].to_f
    end

    #def set_input_effort_per_hour(pbs_project_element)
    #  #TODO i think that elem[:input_effort_per_hour] id from the "Estimation_Value" table (need to know the "module_project_id")
    #  # Also need to know which value from (min, max, most_likely, probable) will be used when running this estimation module
    #  @input_effort_per_hour = pbs_project_element[:input_effort_per_hour]
    #end


    # Getters for module outputs

    # return effort for each Wbs-Activity-Element
    def get_leaf_activity_element_effort(wbs_activity_element)

    end

    # Return effort for each Wbs-Activity node, using aggregation (sum of its element effort)
    def get_node_wbs_activity_element_effort(wbs_activity_element)

    end

    # Return effort of associated Pbs-Element
    def get_pbs_effort_per_hour(pbs_elem)

    end

    # Calculate each Wbs activity effort according to Ratio and Reference_Value
    def get_effort_per_hour

      get_efforts_with_one_activity_element

      #case @module_project.reference_value.value.to_s
      #  # One Activity-element. defined as the reference
      #  when "One Activity-element"
      #    get_efforts_with_one_activity_element
      #
      #  # A set of Activity-elements defined as reference
      #  when "A set of activity-elements"
      #    get_efforts_with_a_set_of_activity_elements
      #
      #  # All Activity-elements defined as reference
      #  when "All Activity-elements"
      #    get_efforts_with_all_activities_elements
      #end
    end


    # Get each wbs-activity-element effort with one activity element as reference
    def get_efforts_with_one_activity_element
      puts "PBS_ID = #{@pbs_project_element.id}"
      puts "PBS_EFFORT = #{@input_effort_per_hour}"

      #project on which estimation is
      project = @module_project.project

      # Project pe_wbs_activity
      pe_wbs_activity = @module_project.project.pe_wbs_projects.wbs_activity.first

      # Get the wbs_project_element which contain the wbs_activity_ratio
      project_wbs_project_elt_root = pe_wbs_activity.wbs_project_elements.elements_root.first
      #wbs_project_elt_with_ratio = WbsProjectElement.where("pe_wbs_project_id = ? and wbs_activity_id = ? and is_added_wbs_root = ?", pe_wbs_activity.id, @pbs_project_element.wbs_activity_id, true).first
      # If we manage more than one wbs_activity per project, this will be depend on the wbs_project_element ancestry(witch has the wbs_activity_ratio)
      wbs_project_elt_with_ratio = project_wbs_project_elt_root.children.where("is_added_wbs_root = ?", true).first

      output_effort = Hash.new

      #pe_wbs_activity.wbs_project_elements.each do |wbs_project_element|
      project_wbs_project_elt_root.descendants.each do |wbs_project_element|
        # A Wbs_project_element is only computed is this module if it has a corresponding Ratio table
        unless wbs_project_element.wbs_activity_element.nil?
          puts "WBS_ACTIVITY_ELEMENT_ID = #{wbs_project_element.id}"
          ratio_reference = nil
          # Use project default Ratio, unless PSB got its own Ratio,
          # If default ratio was defined in PBS, it will override the one defined in module-project
          if @pbs_project_element.wbs_activity_ratio.nil?
            ratio_reference = wbs_project_elt_with_ratio.wbs_activity_ratio
          else
            ratio_reference = @pbs_project_element.wbs_activity_ratio
          end

          #Get the referenced wbs_activity_elt of the ratio_reference
          referenced_ratio_element = WbsActivityRatioElement.where("wbs_activity_ratio_id =? and simple_reference = ?", ratio_reference.id, true).first

          # Element effort is really computed only on leaf element
          if wbs_project_element.is_childless?
            # Get the ratio Value of current element
            corresponding_ratio_value = WbsActivityRatioElement.where("wbs_activity_ratio_id = ? and wbs_activity_element_id = ?", ratio_reference.id, wbs_project_element.wbs_activity_element_id).first.ratio_value
            current_output_effort = (@input_effort_per_hour.to_f * corresponding_ratio_value.to_f / 100) * referenced_ratio_element.ratio_value.to_f
            puts "OUTPUT_EFFORT #{wbs_project_element.id} = #{current_output_effort}"
            output_effort[wbs_project_element.id] = current_output_effort
          end
        end
      end

      # After treating all leaf and node elements, the root element is going to compute by aggregation
      output_effort[project_wbs_project_elt_root.id] = output_effort.inject(0) {|sum, (key,value)| sum += value}
      puts "OUTPUT_EFFORT = #{output_effort}"
      pbs_output_effort = Hash.new
      pbs_output_effort["#{@pbs_project_element.id}"] = output_effort
      puts "PBS_OUTPUT_EFFORT = #{pbs_output_effort}"
      #pbs_output_effort
      output_effort
    end


    # Get each wbs-activity-element effort with a set of activity elements as references
    def get_efforts_with_a_set_of_activity_elements
      product_activity_elements = @pbs_project_element.wbs_project_elements
      reference_activity_elts = product_activity_elements.where("multiple_references = ?", true).all
      referenced_elts_efforts = 0
      reference_activity_elts.each do |ref|
        referenced_elts_efforts += ref.ratio_value.to_f
      end

      product_activity_elements.each do |activity_elt|
        ratio_reference = nil
        # If default ratio was defined in PBS, it will override the one defined in module-project
        if @pbs_project_element.wbs_activity_ratio.nil?
          ratio_reference = WbsProjectElement.where("wbs_activity_id = ?", @pbs_project_element.wbs_activity_id).first
        else
          ratio_reference = @pbs_project_element.wbs_activity_ratio
        end

        #Compute Elements efforts
        corresponding_ratio_value = WbsActivityRatioElement.where("wbs_activity_ratio_id = ? and wbs_activity_element_id = ?", ratio_reference.id, activity_elt.id).ratio_value
        output_effort = (@input_effort_per_hour * corresponding_ratio_value / referenced_elts_efforts)

        return output_effort.to_f
      end
    end


    # Get each wbs-activity-element effort with all activity elements as references
    def get_efforts_with_all_activities_elements
      @pbs_project_element.wbs_project_elements.each do |activity_elt|
        ratio_reference = nil
        # If default ratio was defined in PBS, it will override the one defined in module-project
        if @pbs_project_element.wbs_activity_ratio.nil?
          ratio_reference = WbsProjectElement.where("wbs_activity_id = ?", @pbs_project_element.wbs_activity_id).first
        else
          ratio_reference = @pbs_project_element.wbs_activity_ratio
        end

        #Compute Elements efforts
        corresponding_ratio_value = WbsActivityRatioElement.where("wbs_activity_ratio_id = ? and wbs_activity_element_id = ?", ratio_reference.id, activity_elt.id).ratio_value
        output_effort = (@input_effort_per_hour * corresponding_ratio_value / 100)
        return output_effort
      end
    end
  end
end
