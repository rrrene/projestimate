class Uos::InputsController < ApplicationController
  def index
    @module_project = ModuleProject.find(params[:mp])
    @inputs = @module_project.inputs
    @organization_technologies = current_project.organization.organization_technologies.defined.map{|i| [i.name, i.id]}
    @unit_of_works = current_project.organization.unit_of_works.defined.map{|i| [i.name, i.id]}
    @complexities = current_project.organization.organization_uow_complexities.defined.map{|i| [i.name, i.id]}

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

    def save_uos
      @module_project = ModuleProject.find(params[:module_project_id])
      @organization_technologies = current_project.organization.organization_technologies.defined.map{|i| [i.name, i.id]}
      @unit_of_works = current_project.organization.unit_of_works.defined.map{|i| [i.name, i.id]}
      @complexities = current_project.organization.organization_uow_complexities.defined.map{|i| [i.name, i.id]}

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

      params[:input_id].keys.each do |r|
        input = Input.find_by_id(params[:input_id]["#{r}"].to_i)
        if input.nil?
          input = Input.new
          input.name = params[:name]["#{r}"]
          input.module_project_id = params[:module_project_id]
          input.technology_id = params[:technology]["#{r}"]
          input.unit_of_work_id = params[:uow]["#{r}"]
          input.complexity_id = params[:complexity]["#{r}"]
          input.size_low = params[:size_low]["#{r}"]
          input.size_most_likely = params[:size_most_likely]["#{r}"]
          input.size_high = params[:size_high]["#{r}"]
          input.weight = params[:weight]["#{r}"]
          input.gross_low = params[:gross_low]["#{r}"]
          input.gross_most_likely = params[:gross_most_likely]["#{r}"]
          input.gross_high = params[:gross_high]["#{r}"]
          input.flag = params[:flag]["#{r}"]
          input.save
        else
          input.update_attribute("name", params[:name]["#{r}"])
          input.update_attribute("technology_id", params[:technology]["#{r}"])
          input.update_attribute("unit_of_work_id", params[:uow]["#{r}"])
          input.update_attribute("complexity_id", params[:complexity]["#{r}"])
          input.update_attribute("size_low", params[:size_low]["#{r}"])
          input.update_attribute("size_most_likely", params[:size_most_likely]["#{r}"])
          input.update_attribute("size_high", params[:size_high]["#{r}"])
          input.update_attribute("weight", params[:weight]["#{r}"])
          input.update_attribute("gross_low", params[:gross_low]["#{r}"])
          input.update_attribute("gross_most_likely", params[:gross_most_likely]["#{r}"])
          input.update_attribute("size_high", params[:size_high]["#{r}"])
          input.update_attribute("flag", params[:flag]["#{r}"])
        end
      end


      redirect_to redirect_apply("/uos?mp=#{@module_project.id}", "/uos?mp=#{@module_project.id}",  "/dashboard")
    end

    def load_gross
      @size = Array.new
      @tmp_result = Hash.new
      @result = Hash.new
      @level = ["gross_low", "gross_most_likely", "gross_high"]

      @size << params[:size_low]
      @size << params[:size_ml]
      @size << params[:size_high]

      if params['index']
        @index = params['index'].to_i - 2
      else
        @index = 1
      end

      abacus = AbacusOrganization.where(:organization_id => current_project.organization_id,
                                        :organization_technology_id => params[:technology],
                                        :unit_of_work_id => params[:uow],
                                        :organization_uow_complexity_id => params[:complexity])
      begin
        abacus_value = abacus.first.value
      rescue
        abacus_value = 1
      end

      weight = params[:"weight"].nil? ? 1 : params[:"weight"]

      @result[:"gross_low_#{@index.to_s}"] = params[:size_low].to_i * abacus_value * weight.to_f
      @result[:"gross_most_likely_#{@index.to_s}"] = params[:size_most_likely].to_i * abacus_value * weight.to_f
      @result[:"gross_high_#{@index.to_s}"] = params[:size_high].to_i * abacus_value * weight.to_f
    end
  end
end