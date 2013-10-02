class InputsController < ApplicationController
  def index
    @module_project = ModuleProject.find(params[:mp])
    @in_ev = EstimationValue.where(:module_project_id => @module_project.id,
                                   :pe_attribute_id => @module_project.pemodule.pe_attributes.first.id,
                                   :in_out => "input" ).first
  end

  def save_uos
    @module_project = ModuleProject.find(params[:module_project_id])

    results_out = Hash.new
    results_in = Hash.new

    ["low", "most_likely", "high"].each do |level|
      abacus = AbacusOrganization.where(:organization_id => current_project.organization_id,
                                        :organization_technology_id => params[:technologies],
                                        :unit_of_work_id => params[:uos],
                                        :organization_uow_complexity_id => params[:complexities])
      weight = Float(params[:weight])
      size = Integer(params[:"size_#{level}"])
      abacus_value = abacus.first.value
      results_out[:"string_data_#{level}"] = (size * abacus_value) * weight
      results_in[:"string_data_#{level}"] = size
    end

    @out_ev = EstimationValue.where(:module_project_id => @module_project.id,
                                    :pe_attribute_id => @module_project.pemodule.pe_attributes.first.id,
                                    :in_out => "output" ).first

    @in_ev = EstimationValue.where(:module_project_id => @module_project.id,
                                   :pe_attribute_id => @module_project.pemodule.pe_attributes.first.id,
                                   :in_out => "input" ).first

    ################ OUTPUT ##############

    if @out_ev.nil?
      low = { :pe_attribute_name => @module_project.pemodule.pe_attributes.first.name, current_component.id => results_out[:string_data_low] }
      ml = { :pe_attribute_name => @module_project.pemodule.pe_attributes.first.name, current_component.id => results_out[:string_data_most_likely] }
      high = { :pe_attribute_name => @module_project.pemodule.pe_attributes.first.name, current_component.id => results_out[:string_data_high] }

      EstimationValue.create( :module_project_id => @module_project.id,
                              :pe_attribute_id => @module_project.pemodule.pe_attributes.first.id,
                              :string_data_low => low,
                              :string_data_most_likely => ml,
                              :string_data_high => high,
                              :in_out => "output" )

    else
      ["low", "most_likely", "high"].each do |level|
        level_est_val = @out_ev.send("string_data_#{level}")
        level_est_val[current_component.id] = results_out[:"string_data_#{level}"]
        @out_ev.update_attributes(:"string_data_#{level}" => level_est_val)
      end
    end


    ################ INPUT ##############
    if @in_ev.nil?
      low = { :pe_attribute_name => @module_project.pemodule.pe_attributes.first.name, current_component.id => results_in[:string_data_low] }
      ml = { :pe_attribute_name => @module_project.pemodule.pe_attributes.first.name, current_component.id => results_in[:string_data_most_likely] }
      high = { :pe_attribute_name => @module_project.pemodule.pe_attributes.first.name, current_component.id => results_in[:string_data_high] }

      EstimationValue.create( :module_project_id => @module_project.id,
                              :pe_attribute_id => @module_project.pemodule.pe_attributes.first.id,
                              :string_data_low => low,
                              :string_data_most_likely => ml,
                              :string_data_high => high,
                              :in_out => "input" )
    else
      ["low", "most_likely", "high"].each do |level|
        level_est_val = @in_ev.send("string_data_#{level}")
        level_est_val[current_component.id] = results_in[:"string_data_#{level}"]
        @in_ev.update_attributes(:"string_data_#{level}" => level_est_val)
      end
    end

    redirect_to "/dashboard"

  end
end
