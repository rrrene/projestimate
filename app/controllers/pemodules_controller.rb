class PemodulesController < ApplicationController

  def index
    authorize! :manage_modules, Pemodule
    set_page_title "Modules"
    @pemodules = Pemodule.all
  end

  def new
    authorize! :manage_modules, Pemodule
    set_page_title "New Modules"
    @wets = WorkElementType.all.reject{|i| i.name == "Folder" || i.name == "Link"}
    @pemodule = Pemodule.new
    @attributes = Attribute.all
    @attr_modules = []
  end

  def edit
    authorize! :manage_modules, Pemodule
    set_page_title "Edit Modules"
    @wets = WorkElementType.all.reject{|i| i.name == "Folder" || i.name == "Link"}
    @pemodule = Pemodule.find(params[:id])
    @attributes = Attribute.all
    @attr_modules = AttributeModule.all(:conditions => {:pemodule_id => @pemodule.id})
  end

  def update
    authorize! :manage_modules, Pemodule

    parameters = {:title => params[:title], :description => params[:description], :alias => params[:alias], :compliant_component_type => params[:compliant_wet], :is_typed => params[:is_typed]}

    if params[:is_typed] == "false"
      AttributeModule.where(:pemodule_id => params[:id]).each do |attr|
        attr.delete
      end
    end

    unless params[:id].blank?
      @pemodule = Pemodule.find(params[:id])
      @pemodule.update_attributes(parameters)
    else
      @pemodule = Pemodule.new(parameters)
      @pemodule.save
    end

    redirect_to edit_pemodule_path(@pemodule), :notice => "The changes have been saved correctly"
  end

  #Update attribute of the pemodule selected (2nd tabs)
  #TODO:needs some improvements
  def update_selected_attributes
    authorize! :manage_modules, Pemodule
    attribute_ids = AttributeModule.all.map(&:attribute_id)
    params[:attributes].each do |attr|
      conditions = {:attribute_id => attr, :pemodule_id => params[:module_id]}
      AttributeModule.first(:conditions => conditions) || AttributeModule.create(conditions)
    end

    (attribute_ids - params[:attributes].map{|i| i.to_i}).each do |attr|
      attrmdl = AttributeModule.find_by_attribute_id_and_pemodule_id(attr, params[:module_id])
      if attrmdl
        attrmdl.delete
      end
    end

    @attr_modules = AttributeModule.all(:conditions => {:pemodule_id => params[:module_id]})

    redirect_to edit_pemodule_path(params[:module_id]), :notice => "The changes have been saved correctly"
  end

  #Update attribute settings (3th tabs)
  def set_attributes_module
    authorize! :manage_modules, Pemodule
    selected_attributes = params[:attributes]
    selected_attributes.each_with_index do |attr, i|
      conditions = {:attribute_id => attr.to_i, :pemodule_id => params[:module_id]}
      attribute = AttributeModule.first(:conditions => conditions)
      attribute.update_attribute("in_out", params[:in_out][i])
      attribute.update_attribute("is_mandatory", params[:is_mandatory][i])
      attribute.update_attribute("description", params[:description][i])
      attribute.update_attribute("custom_attribute", params[:custom_attribute][i])
      #TODO: save string and date value
      attribute.update_attribute("numeric_data_low", params[:numeric_data_low][i])
      attribute.update_attribute("numeric_data_most_likely", params[:numeric_data_most_likely][i])
      attribute.update_attribute("numeric_data_high", params[:numeric_data_high][i])
      if params[:custom_attribute][i] == "user"
        attribute.update_attribute("project_value", nil)
      else
        attribute.update_attribute("project_value", params[:project_value][i])
      end
    end

    redirect_to edit_pemodule_path(params[:module_id]), :notice => "The changes have been saved correctly"
  end

  # DELETE //1
  # DELETE //1.json
  def destroy
    authorize! :manage_modules, Pemodule
    @pemodule = Pemodule.find(params[:id])
    @pemodule.destroy

    redirect_to _url
  end


  #Move functions
  #Move the module down or to the right one step
  def pemodules_up
    @project_module = ModuleProject.find(params[:project_module_id])
    @project = @project_module.project

    my_module = ModuleProject.find_by_project_id_and_id(@project.id, @project_module.id)
    if my_module.position_y > 1
      my_module.update_attribute("position_y", my_module.position_y-1)
    end
    @array_module_positions = ModuleProject.where(:project_id => @project.id).all.map(&:position_y).uniq.max || 1

    redirect_to edit_project_path(@project)
  end

  #Move the module up or to the left one step
  def pemodules_down
    @project_module = ModuleProject.find(params[:project_module_id])
    @project = @project_module.project

    my_module = ModuleProject.find_by_project_id_and_id(@project.id, @project_module.id)
    @array_module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
    my_module.update_attribute("position_y", my_module.position_y+1)

    redirect_to edit_project_path(@project)
  end

  def estimations_params
    set_page_title "Estimations parameters"
  end

end
