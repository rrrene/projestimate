class InputsController < ApplicationController
  def index
    @module_project = ModuleProject.find(params[:mp])
    @module_project.pemodule.attribute_modules.select{|i| i.in_out == "input"}.each do |am|
      if am.pe_attribute.alias ==  "size"
        @size = EstimationValue.where(:module_project_id => @module_project.id,
                                     :pe_attribute_id => am.pe_attribute.id,
                                     :in_out => "input" ).first
      else
        @gross_size = EstimationValue.where(:module_project_id => @module_project.id,
                                             :pe_attribute_id => am.pe_attribute.id,
                                             :in_out => "input" ).first
      end
    end
  end

  def save_uos
    @module_project = ModuleProject.find(params[:module_project_id])

    results_out = Hash.new
    results_in = Hash.new
    results_gross_size = Hash.new

    ["low", "most_likely", "high"].each do |level|
      abacus = AbacusOrganization.where(:organization_id => current_project.organization_id,
                                        :organization_technology_id => params[:technologies],
                                        :unit_of_work_id => params[:uos],
                                        :organization_uow_complexity_id => params[:complexities])
      weight = params[:weight].blank? ? 1 : Float(params[:weight])
      size = Integer(params[:"size_#{level}"])
      abacus_value = abacus.first.value
      results_out[:"string_data_#{level}"] = (size * abacus_value) * weight
      results_in[:"string_data_#{level}"] = size
      results_gross_size[:"string_data_#{level}"] = params[:"gross_#{level}"]
    end

    @module_project.pemodule.attribute_modules.select{|i| i.in_out == "output"}.each do |am|
      @out_ev = EstimationValue.where(:module_project_id => @module_project.id,
                                      :pe_attribute_id => am.pe_attribute.id,
                                      :in_out => "output" ).first

        ["low", "most_likely", "high"].each do |level|
          level_est_val = @out_ev.send("string_data_#{level}")
          level_est_val[current_component.id] = results_out[:"string_data_#{level}"]
          @out_ev.update_attributes(:"string_data_#{level}" => level_est_val)
        end
    end

    @module_project.pemodule.attribute_modules.select{|i| i.in_out == "input"}.each do |am|
      @in_ev = EstimationValue.where(:module_project_id => @module_project.id,
                                   :pe_attribute_id => am.pe_attribute.id,
                                   :in_out => "input" ).first

        ["low", "most_likely", "high"].each do |level|
          level_est_val = @in_ev.send("string_data_#{level}")
          if am.pe_attribute.alias == "gross_size"
            level_est_val[current_component.id] = results_gross_size[:"string_data_#{level}"]
          else
            level_est_val[current_component.id] = results_in[:"string_data_#{level}"]
          end
          @in_ev.update_attributes(:"string_data_#{level}" => level_est_val)
      end
    end

    redirect_to redirect_apply("/uos?mp=#{@module_project.id}", "/uos?mp=#{@module_project.id}",  "/dashboard")

  end

  def load_gross
    @result = Hash.new
    weight = params[:weight].blank? ? 1 : Float(params[:weight])
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
