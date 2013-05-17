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
    @wets = WorkElementType.all.reject{|i| i.alias == 'link' || i.alias == 'folder'
    }
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
    if @pemodule.update_attributes(params[:pemodule])
      flash[:notice] =  I18n.t (:notice_pemodule_successful_updated)
    else
      flash[:error] = "#{@pemodule.errors.full_messages.to_sentence}"
    end
    redirect_to redirect(edit_pemodule_path(@pemodule))  #redirect_to redirect(pemodules_url)
  end


  def create
    @pemodule = Pemodule.new(params[:pemodule])

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
      @pemodule.attribute_modules.create(:pe_attribute_id => g, :record_status_id => @pemodule.record_status_id) unless g.blank?
    end
    @pemodule.pe_attributes(force_reload = true)

    if @pemodule.save
      flash[:notice] = I18n.t (:notice_pemodule_successful_updated)
    else
      flash[:notice] = I18n.t (:error_administration_setting_failed_update)
    end

    @attribute_settings = AttributeModule.all(:conditions => {:pemodule_id => params[:module_id]})
    redirect_to edit_pemodule_path(params[:module_id], :anchor => 'tabs-3')
  end

  #Update attribute settings (3th tabs)
  def set_attributes_module
    authorize! :manage_modules, Pemodule
    selected_attributes = params[:attributes]
    selected_attributes.each_with_index do |attr, i|
      conditions = {:pe_attribute_id => attr.to_i, :pemodule_id => params[:module_id]}
      attribute = AttributeModule.first(:conditions => conditions)
      attribute.update_attribute('in_out', params[:in_out][i])
      attribute.update_attribute('is_mandatory', params[:is_mandatory][i])
      attribute.update_attribute('description', params[:description][i])
      attribute.update_attribute('custom_attribute', params[:custom_attribute][i])

      attribute.update_attribute('default_low', params[:default_low][i])
      attribute.update_attribute('default_most_likely', params[:default_most_likely][i])
      attribute.update_attribute('default_high', params[:default_high][i])

      if params[:custom_attribute][i] == 'user'
        attribute.update_attribute('project_value', nil)
      else
        attribute.update_attribute('project_value', params[:project_value][i])
      end
    end

    redirect_to edit_pemodule_path(params[:module_id]), :notice => "#{I18n.t (:notice_pemodule_successful_updated)}"
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


  #################### Move functions ####################
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
      @project_module.associated_module_projects.delete_all
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
    @project_module.associated_module_projects.delete_all

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

  def estimations_params
    set_page_title 'Estimations parameters'
  end

end
