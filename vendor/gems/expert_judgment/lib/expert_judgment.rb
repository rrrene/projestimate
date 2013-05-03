require 'expert_judgment/version'

module ExpertJudgment

  # Expert Judgment gem definition
  class ExpertJudgment
    attr_accessor :effort_man_hour, :minimum, :most_likely, :maximum, :probable, :pbs_project_element_id, :wbs_project_element_root

    def initialize(elem)
      WbsProjectElement.rebuild_depth_cache!
      @effort_man_hour = elem[:effort_man_hour]
      set_minimum(elem)
      set_maximum(elem)
      set_most_likely(elem)
      set_wbs_project_element_root(elem)
    end

    def set_minimum(elem)
      @minimum = elem[:minimum].to_f
    end

    def set_maximum(elem)
      @maximum = elem[:maximum].to_f
    end

    def set_most_likely(elem)
      @most_likely = elem[:most_likely].to_f
    end

    def set_probable
      ( (@minimum + (4*@most_likely) + @maximum) / 6 ).to_f
    end

    #Set the WBS-activity node elements effort using aggregation (sum) of child elements (from the bottom up)
    def set_node_effort_man_hour(node)
    end

    #Get the project WBS root
    def set_wbs_project_element_root(elem)
      @pbs_project_element = PbsProjectElement.find(elem[:pbs_project_element_id])
      current_project = @pbs_project_element.pe_wbs_project.project
      pe_wbs_project_activity = current_project.pe_wbs_projects.wbs_activity.first
      @wbs_project_element_root = pe_wbs_project_activity.wbs_project_elements.where("is_root = ?", true).first
    end

    #GETTERS
    def get_effort_man_hour
      new_effort_man_hour = Hash.new
      root_element_effort_man_hour = 0.0

      @wbs_project_element_root.children.each do |node|
        # Sort node subtree by ancestry_depth
        sorted_node_elements = node.subtree.order('ancestry_depth desc')
        sorted_node_elements.each do |wbs_project_element|
          if wbs_project_element.is_childless?
            new_effort_man_hour[wbs_project_element.id] = @effort_man_hour[wbs_project_element.id.to_s].to_f
          else
            node_effort = 0
            wbs_project_element.children.each do |child|
              node_effort = node_effort + new_effort_man_hour[child.id]
            end
            new_effort_man_hour[wbs_project_element.id] = node_effort
          end
        end

        #compute the wbs root effort
        root_element_effort_man_hour = root_element_effort_man_hour + new_effort_man_hour[node.id]
      end

      new_effort_man_hour[@wbs_project_element_root.id] = root_element_effort_man_hour

      new_effort_man_hour
    end

  end

end
