module InputsHelper

  def display_uos_module(module_project_id)
    "<h4>Estimation inputs</h4>
    #{ link_to "Fill input data", "/uos?mp=#{module_project_id}" }"
  end

  def method_missing(method, *args, &block)
    if (method.to_s.end_with?('_path') || method.to_s.end_with?('_url')) && main_app.respond_to?(method)
      main_app.send(method, *args)
    else
      super
    end
  end
end
