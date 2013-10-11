class InputsController < ApplicationController
  def index
    @module_project = ModuleProject.find(params[:mp])
    @inputs = @module_project.inputs
    @module_project.pemodule.attribute_modules.each do |am|
      if am.pe_attribute.alias ==  "size"
        @size = EstimationValue.where(:module_project_id => @module_project.id,
                                     :pe_attribute_id => am.pe_attribute.id,
                                     :in_out => "input" ).first
      else
        @gross_size = EstimationValue.where(:module_project_id => @module_project.id,
                                             :pe_attribute_id => am.pe_attribute.id,
                                             :in_out => "output" ).first
      end
    end
  end

  def save_uos
    @module_project = ModuleProject.find(params[:module_project_id])

    @module_project.pemodule.attribute_modules.each do |am|
      @in_ev = EstimationValue.where(:module_project_id => @module_project.id,
                                     :pe_attribute_id => am.pe_attribute.id).first

      ["low", "most_likely", "high"].each do |level|
        if am.pe_attribute.alias == "size"
          level_est_val = @in_ev.send("string_data_#{level}")
          level_est_val[current_component.id] = params[:"overall_size_#{level}"]
        elsif am.pe_attribute.alias == "effort_man_hour"
          level_est_val = @in_ev.send("string_data_#{level}")
          level_est_val[current_component.id] = params[:"overall_gross_#{level}"]
        end
        @in_ev.update_attribute(:"string_data_#{level}", level_est_val)
      end
    end


    input = Input.new
    input.name = params[:name]["1"]
    input.module_project_id = params[:module_project_id]
    input.technology_id = params[:technologies]["1"]
    input.unit_of_work_id = params[:uows]["1"]
    input.complexity_id = params[:complexities]["1"]
    input.size_low = params[:size_low]["1"]
    input.size_most_likely = params[:size_most_likely]["1"]
    input.size_high = params[:size_high]["1"]
    input.weight = params[:weight]["1"]
    input.gross_low = params[:gross_low]["1"]
    input.gross_most_likely = params[:gross_most_likely]["1"]
    input.gross_high = params[:gross_high]["1"]
    input.save

    redirect_to redirect_apply("/uos?mp=#{@module_project.id}", "/uos?mp=#{@module_project.id}",  "/dashboard")
  end

  def load_gross
    @result = Hash.new
    weight = params[:weight].blank? ? 1 : 2
    size = params[:size].to_i
    abacus = AbacusOrganization.where(:organization_id => current_project.organization_id,
                                      :organization_technology_id => params[:technology],
                                      :unit_of_work_id => params[:uow],
                                      :organization_uow_complexity_id => params[:complexity])
    abacus_value = abacus.first.value
    @level = (params[:level] == "undefined") ? ["low", "most_likely", "high"] : [params[:level]]
    @level.each do |l|
      @result[l] = (size * abacus_value) * weight
    end
  end
end
