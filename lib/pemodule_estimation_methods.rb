# Module that contains all generic methods for Projestimate modules estimations calculation
module PemoduleEstimationMethods

  # method that compute not leaf node estimation value by aggregation
  def compact_array_and_compute_node_value(node, effort_array)
    tab = []
    node.children.map do |child|
      value = effort_array[child.id]
      if value.is_a?(Integer) || value.is_a?(Float)
        tab << value
      end
    end

    estimation_value = nil
    unless tab.empty?
      estimation_value = tab.compact.sum
    end

    estimation_value
  end
end