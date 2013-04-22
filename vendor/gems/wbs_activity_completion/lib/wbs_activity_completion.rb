require "wbs_activity_completion/version"

module WbsActivityCompletion
  # Module Class
  class WbsActivityCompletion
    attr_accessor :pbs_project_element, :inputs_effort_man_hour

    # table_inputs_effort_per_hour : is table that contains values set on each wbs-activity by user (from the project estimation view)
    # module_input_data: is a Hash each activity  with its corresponding effort
    def initialize(module_input_data)
      puts "MODULE_INPUT_DATA = #{module_input_data}"
      @pbs_project_element = PbsProjectElement.find(module_input_data[:pbs_project_element_id])
      @inputs_effort_man_hour = module_input_data[:effort_man_hour]
    end

    # The Output result
    def get_effort_man_hour
      @inputs_effort_man_hour
    end
  end
end
