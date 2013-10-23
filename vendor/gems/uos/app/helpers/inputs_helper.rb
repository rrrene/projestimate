module InputsHelper
  def display_uos_module(module_project_id)
    "<h4>Estimation inputs</h4>
    #{ link_to "Fill input data", "/uos?mp=#{module_project_id}" }"
  end
end
