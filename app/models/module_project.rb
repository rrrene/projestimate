#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012 Spirula (http://www.spirula.fr)

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

class ModuleProject < ActiveRecord::Base
  belongs_to :pemodule
  belongs_to :project
  belongs_to :reference_value

  has_many :estimation_values
  has_and_belongs_to_many :pbs_project_elements

  has_and_belongs_to_many :associated_module_projects, :class_name => "ModuleProject",
           :join_table => "associated_module_projects",
           :association_foreign_key => :associated_module_project_id,
           :uniq => true

  default_scope :order => "position_x ASC, position_y ASC"

  amoeba do
    enable
    include_field [:estimation_values, :pbs_project_elements]

    customize(lambda { |original_module_project, new_module_project|
      new_module_project.copy_id = original_module_project.id
    })

  end

  #Return the common attributes (previous, next)
  def self.common_attributes(mp1, mp2)
    mp1.output_attributes & mp2.input_attributes
  end

  #Return in a array next modules project of self.
  def following
    pos = self.position_y.to_i
    mps = ModuleProject.where("position_y > #{pos} AND project_id = #{self.project.id}")
  end

  #Return in a array previous modules project of self.
  def preceding
    pos = self.position_y.to_i
    mps = ModuleProject.where("position_y < #{pos} AND project_id = #{self.project.id}")
  end

  #Return the outputs attributes of a module_projects
  def output_attributes
    res = Array.new
    self.estimation_values.each do |est_val|
      if est_val.in_out == 'output'
        res << est_val.pe_attribute
      end
    end
    res
  end

  #Return the inputs attributes of a module_projects
  def input_attributes
    res = Array.new
    self.estimation_values.each do |est_val|
      if est_val.in_out == 'input'
        res << est_val.pe_attribute
      end
    end
    res
  end

  #Return the next pemodule with link
  def next
    results = Array.new
    tmp_results = self.associated_module_projects #+self.inverse_associated_module_projects
    tmp_results.each do |r|
      if self.following.map(&:id).include?(r.id)
        results << r
      end
    end
    results
  end

  #Return the previous pemodule with link
  def previous
    results = Array.new
    #tmp_results = (self.inverse_associated_module_projects + self.associated_module_projects)
    tmp_results = self.associated_module_projects
    tmp_results.each do |r|
      if self.preceding.map(&:id).include?(r.id)
        results << r
      end
    end
    results
  end

  def links
    self.associated_module_project_ids
  end

  def compatible_with(wet_alias)
    if self.pemodule.compliant_component_type.nil?
      false
    else
      self.pemodule.compliant_component_type.include?(wet_alias)
    end
  end

  def to_s
    self.pemodule.title
  end

  def is_One_Activity_Element?
    begin
      if self.reference_value.value==I18n.t(:one_activity_element)
        return true
      else
        return false
      end
    rescue
      return false
    end
  end

  def is_All_Activity_Elements?
    begin
      if self.reference_value.value==I18n.t(:all_activity_elements)
        return true
      else
        return false
      end
    rescue
      return false
    end
  end

  def is_A_Set_Of_Activity_Elements?
    begin
      if self.reference_value.value==I18n.t(:all_activity_elements)
        return true
      else
        return false
      end
    rescue
      return false
    end
  end

end
