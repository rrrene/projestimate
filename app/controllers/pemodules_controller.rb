#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012-2013 Spirula (http://www.spirula.fr)
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

class PemodulesController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses
  before_filter :project_locked?,  :only => [:pemodules_right, :pemodules_left, :pemodules_up, :pemodules_down]

  def index
    authorize! :manage_modules, Pemodule
    set_page_title 'Modules'
    @pemodules = Pemodule.all
    @attributes = PeAttribute.all
  end

  def new
    authorize! :manage_modules, Pemodule
    set_page_title 'New Modules'
    @wets = WorkElementType.all.reject{|i| i.alias == 'link' || i.alias == 'folder'
    }
    @pemodule = Pemodule.new
    @attributes = PeAttribute.all
    @attribute_settings = []
  end

  def edit
    authorize! :manage_modules, Pemodule
    set_page_title 'Edit Modules'
    @wets = WorkElementType.all.reject{|i| i.alias == 'link' || i.alias == 'folder'
    }
    @pemodule = Pemodule.find(params[:id])
    @attributes = PeAttribute.all
    @attribute_settings = AttributeModule.all(:conditions => {:pemodule_id => @pemodule.id})

    unless @pemodule.child_reference.nil?
      if @pemodule.child_reference.is_proposed_or_custom?
        flash[:warning] = I18n.t (:warning_pemodule_cant_be_edit)
        redirect_to pemodules_path

      end
    end
  end

  def update
    @wets = WorkElementType.all.reject{|i| i.alias == 'link' || i.alias == 'folder'}
    @attributes = PeAttribute.all

    @pemodule = nil
    current_pemodule = Pemodule.find(params[:id])
    if current_pemodule.is_defined?
      @pemodule = current_pemodule.amoeba_dup
      @pemodule.owner_id = current_user.id
    else
      @pemodule = current_pemodule
    end

    @attribute_settings = AttributeModule.all(:conditions => {:pemodule_id => @pemodule.id})
    @pemodule.compliant_component_type = params[:compliant_wet]

    #if @pemodule.save#(:validate => false)
    params[:pemodule][:alias] = params[:pemodule][:alias].downcase
    if @pemodule.update_attributes(params[:pemodule])
      flash[:notice] =  I18n.t (:notice_pemodule_successful_updated)
    else
      flash[:error] = "#{@pemodule.errors.full_messages.to_sentence}"
    end
    redirect_to redirect(pemodules_path), :notice => "#{I18n.t (:notice_module_project_successful_updated)}"
  end


  def create
    @pemodule = Pemodule.new(params[:pemodule])
    @pemodule.alias =  params[:pemodule][:alias].downcase

    @pemodule.compliant_component_type = params[:compliant_wet]
    @wets = WorkElementType.all.reject{|i| i.alias == 'link'
    }
    @attributes = PeAttribute.all
    @attribute_settings = []

    if @pemodule.save
      redirect_to redirect(pemodules_url)

    else
      render :new
    end
  end


  #Update attribute of the pemodule selected (2nd tabs)
  def update_selected_attributes
    authorize! :manage_modules, Pemodule
    @pemodule = Pemodule.find(params[:module_id])

    attributes_ids = params[:pemodule][:pe_attribute_ids]

    @pemodule.attribute_modules.each do |m|
      m.destroy unless attributes_ids.include?(m.pe_attribute_id.to_s)
      attributes_ids.delete(m.pe_attribute_id.to_s)
    end

    #Attribute module record_status is according to the Pemodule record_status
    attributes_ids.each do |g|
      #For Capitalization module : all attributes are input/output (both)
      if @pemodule.alias == "Capitalization"
        @pemodule.attribute_modules.create(:pe_attribute_id => g, :in_out => "both", :record_status_id => @pemodule.record_status_id) unless g.blank?
      else
        @pemodule.attribute_modules.create(:pe_attribute_id => g, :record_status_id => @pemodule.record_status_id) unless g.blank?
      end
    end
    @pemodule.pe_attributes(force_reload = true)

    if @pemodule.save
      flash[:notice] = I18n.t (:notice_pemodule_successful_updated)
    else
      flash[:notice] = I18n.t (:error_administration_setting_failed_update)
    end

    @attribute_settings = AttributeModule.all(:conditions => {:pemodule_id => params[:module_id]})
    redirect_to redirect(pemodules_path), :notice => "#{I18n.t (:notice_module_project_successful_updated)}"
    #redirect_to redirect_save(pemodules_path, edit_pemodule_path(params[:module_id], :anchor=>'tabs-2')), :notice => "#{I18n.t (:notice_module_project_successful_updated)}"
  end


  #Update attribute settings (3th tabs)
  def set_attributes_module
    authorize! :manage_modules, Pemodule

    @pemodule = Pemodule.find(params[:module_id])

    selected_attributes = params[:attributes]
    selected_attributes.each_with_index do |attr, i|
      conditions = {:pe_attribute_id => attr.to_i, :pemodule_id => params[:module_id]}
      attribute_module = AttributeModule.first(:conditions => conditions)


      project_value = nil
      unless params[:custom_attribute][i] == 'user'
        project_value = params[:project_value][i]
      end

      attribute_module.update_attributes(:in_out =>  params[:in_out][i], :is_mandatory => params[:is_mandatory][i], :display_order => params[:display_order][i],
                                  :description => params[:description][i], :custom_attribute => params[:custom_attribute][i], :default_low =>  params[:default_low][i],
                                  :default_most_likely =>  params[:default_most_likely][i], :default_high =>  params[:default_high][i], :project_value => project_value)
    end


    #If new Attributes are added or deleted : the Estimation_value table need to be updated
    #my_module_project.pemodule.attribute_modules.each do |am|
    #  if am.in_out == 'both'
    #    ['input', 'output'].each do |in_out|
    #      mpa = EstimationValue.create(:pe_attribute_id => am.pe_attribute.id,
    #                                   :module_project_id => my_module_project.id,
    #                                   :in_out => in_out,
    #                                   :is_mandatory => am.is_mandatory,
    #                                   :description => am.description,
    #                                   :display_order => am.display_order,
    #                                   :string_data_low => {:pe_attribute_name => am.pe_attribute.name, :default_low => am.default_low},
    #                                   :string_data_most_likely => {:pe_attribute_name => am.pe_attribute.name, :default_most_likely => am.default_most_likely},
    #                                   :string_data_high => {:pe_attribute_name => am.pe_attribute.name, :default_high => am.default_high},
    #                                   :custom_attribute => am.custom_attribute,
    #                                   :project_value => am.project_value)
    #    end
    #  else
    #    mpa = EstimationValue.create(:pe_attribute_id => am.pe_attribute.id,
    #                                 :module_project_id => my_module_project.id,
    #                                 :in_out => am.in_out,
    #                                 :is_mandatory => am.is_mandatory,
    #                                 :display_order => am.display_order,
    #                                 :description => am.description,
    #                                 :string_data_low => {:pe_attribute_name => am.pe_attribute.name, :default_low => am.default_low},
    #                                 :string_data_most_likely => {:pe_attribute_name => am.pe_attribute.name, :default_most_likely => am.default_most_likely},
    #                                 :string_data_high => {:pe_attribute_name => am.pe_attribute.name, :default_high => am.default_high},
    #                                 :custom_attribute => am.custom_attribute,
    #                                 :project_value => am.project_value)
    #  end
    #end

    redirect_to redirect_save(pemodules_path, edit_pemodule_path(params[:module_id], :anchor=>'tabs-3')), :notice => "#{I18n.t (:notice_module_project_successful_updated)}"

  end

  def destroy
    authorize! :manage_modules, Pemodule
    @pemodule = Pemodule.find(params[:id])
    if @pemodule.is_defined? || @pemodule.is_custom?
      #logical deletion: delete don't have to suppress records anymore
      @pemodule.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
    else
      @pemodule.destroy
    end

    redirect_to pemodules_url, :notice => "#{I18n.t (:notice_pemodule_successful_deleted)}"
  end

  def estimations_params
    set_page_title 'Estimations parameters'
  end


  #TODO: ####################  Move functions to module_projects_controller ####################

  def pemodules_up
    @project_module = ModuleProject.find(params[:module_id])
    @project = @project_module.project

    if @project_module.position_y > 1
      current_pmodule = @project.module_projects.where("position_x =? AND position_y =?", @project_module.position_x, @project_module.position_y.to_i-1).first
      if current_pmodule
        current_pmodule.update_attribute('position_y', @project_module.position_y.to_i)
      end
      @project_module.update_attribute('position_y', @project_module.position_y.to_i - 1)

      #Remove existing links between modules (for impacted modules only)
      ActiveRecord::Base.connection.execute("DELETE FROM associated_module_projects WHERE module_project_id = #{@project_module.id} OR associated_module_project_id = #{@project_module.id} ")
    end

    @module_positions = ModuleProject.where(:project_id => @project.id).all.map(&:position_y).uniq.max || 1
    redirect_to edit_project_path(@project.id, :anchor => 'tabs-4')
  end


  def pemodules_down
    @project_module = ModuleProject.find(params[:module_id])
    @project = @project_module.project

    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1

    current_pmodule = @project.module_projects.where("position_x =? AND position_y =?", @project_module.position_x, @project_module.position_y+1).first
    if current_pmodule
      current_pmodule.update_attribute('position_y', @project_module.position_y.to_i)
    end

    @project_module.update_attribute('position_y', @project_module.position_y.to_i + 1 )

    #Remove existing links between modules (for impacted modules only)
    ActiveRecord::Base.connection.execute("DELETE FROM associated_module_projects WHERE module_project_id = #{@project_module.id} OR associated_module_project_id = #{@project_module.id} ")

    redirect_to edit_project_path(@project.id, :anchor => 'tabs-4')
  end


  def pemodules_left
    @project_module = ModuleProject.find(params[:module_id])
    @project = @project_module.project

    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1
    if @project_module.position_x.to_i > 1
      current_pmodule = @project.module_projects.where("position_x =? AND position_y =?", @project_module.position_x.to_i-1, @project_module.position_y).first
      if current_pmodule
        current_pmodule.update_attribute('position_x', @project_module.position_x.to_i)
      end

      @project_module.update_attribute('position_x', @project_module.position_x.to_i - 1 )
    end
    redirect_to edit_project_path(@project.id, :anchor => 'tabs-4')
  end


  def pemodules_right
    @project_module = ModuleProject.find(params[:module_id])
    @project = @project_module.project

    @module_positions = ModuleProject.where(:project_id => @project.id).order(:position_y).all.map(&:position_y).uniq.max || 1

    current_pmodule = @project.module_projects.where("position_x =? AND position_y =?", @project_module.position_x.to_i+1, @project_module.position_y.to_i).first
    if current_pmodule
      current_pmodule.update_attribute('position_x', @project_module.position_x.to_i)
    end

    @project_module.update_attribute('position_x', @project_module.position_x.to_i + 1 )

    redirect_to edit_project_path(@project.id, :anchor => 'tabs-4')
  end

end
