#########################################################################
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

module ModuleProjectsHelper

  # Compute the probable result for each node
  # results: estimation result for (low, most_likely, high)
  # estimation_value : the estimation_value object
  def probable_value(results, estimation_value)
    minimum = 0.0
    most_likely = 0.0
    maximum = 0.0
    attribute_alias = estimation_value.pe_attribute.alias.to_sym
    #puts "RESULT_FOR_PROBABLE = #{results}"
    min_estimation_value = results[:low]["#{estimation_value.pe_attribute.alias}_#{estimation_value.module_project_id.to_s}".to_sym]
    most_likely_estimation_value = results[:most_likely]["#{estimation_value.pe_attribute.alias}_#{estimation_value.module_project_id.to_s}".to_sym]
    high_estimation_value = results[:high]["#{estimation_value.pe_attribute.alias}_#{estimation_value.module_project_id.to_s}".to_sym]

    # Get the current estimation Module
    estimation_pemodule = estimation_value.module_project.pemodule
    if estimation_pemodule.yes_for_output_with_ratio? || estimation_pemodule.yes_for_output_without_ratio? || estimation_pemodule.yes_for_input_output_with_ratio? || estimation_pemodule.yes_for_input_output_without_ratio?
      hash_data_probable = Hash.new
      min_estimation_value.keys.each do |wbs_project_elt_id|
        minimum = min_estimation_value[wbs_project_elt_id].to_f
        most_likely = most_likely_estimation_value[wbs_project_elt_id].to_f
        maximum = high_estimation_value[wbs_project_elt_id].to_f

        hash_data_probable[wbs_project_elt_id] = (minimum + 4*most_likely + maximum) / 6
      end
      hash_data_probable
    else
      data_probable =  (min_estimation_value.to_f + 4*most_likely_estimation_value.to_f + high_estimation_value.to_f) / 6
    end
  end
end
