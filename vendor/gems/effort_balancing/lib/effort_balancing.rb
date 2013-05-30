require "effort_balancing/version"

module EffortBalancing
  class EffortBalancing
    include PemoduleEstimationMethods
    attr_accessor :effort_man_hour, :note, :wbs_project_element_root

    def initialize(elem)
      @effort_man_hour = elem[:effort_man_hour]
      @note = elem[:note]
      set_wbs_project_element_root(elem)
    end

    #Get the project WBS root
    def set_wbs_project_element_root(elem)
      @pbs_project_element = PbsProjectElement.find(elem[:pbs_project_element_id])
      current_project = @pbs_project_element.pe_wbs_project.project
      pe_wbs_project_activity = current_project.pe_wbs_projects.wbs_activity.first
      @wbs_project_element_root = pe_wbs_project_activity.wbs_project_elements.where("is_root = ?", true).first
    end

    def get_effort_man_hour
      new_effort_man_hour = Hash.new
      root_element_effort_man_hour = 0.0

      @wbs_project_element_root.children.each do |node|
        # Sort node subtree by ancestry_depth
        sorted_node_elements = node.subtree.order('ancestry_depth desc')
        sorted_node_elements.each do |wbs_project_element|
          if wbs_project_element.is_childless?
            new_effort_man_hour[wbs_project_element.id] = (@effort_man_hour[wbs_project_element.id.to_s].blank? ? nil : @effort_man_hour[wbs_project_element.id.to_s].to_f)
          else
            node_effort = 0.0
            wbs_project_element.children.each do |child|
              node_effort = node_effort + new_effort_man_hour[child.id]
            end
            new_effort_man_hour[wbs_project_element.id] = compact_array_and_compute_node_value(wbs_project_element, new_effort_man_hour)
          end
        end
      end

      new_effort_man_hour[@wbs_project_element_root.id] = compact_array_and_compute_node_value(@wbs_project_element_root, new_effort_man_hour)

      new_effort_man_hour
    end

    def get_note
      new_note = Hash.new

      @wbs_project_element_root.children.each do |node|
        # Sort node subtree by ancestry_depth
        sorted_node_elements = node.subtree.order('ancestry_depth desc')
        sorted_node_elements.each do |wbs_project_element|
          wbs_project_element.children.each do |child|
            new_note[wbs_project_element.id] = @note[wbs_project_element.id.to_s]
          end
        end
      end
      new_note
    end

  end
end
