#encoding: utf-8
#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012 Spirula (http://www.spirula.fr)
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


class Project < ActiveRecord::Base
  include AASM
  include ActionView::Helpers

  belongs_to :organization
  belongs_to :project_area
  belongs_to :acquisition_category
  belongs_to :platform_category
  belongs_to :project_category

  has_many :events
  has_many :module_projects, :dependent => :destroy
  has_many :pemodules, :through => :module_projects

  #has_one :pe_wbs_project, :dependent => :destroy
  has_many :pe_wbs_projects, :dependent => :destroy

  has_and_belongs_to_many :groups
  has_and_belongs_to_many :users

  serialize :included_wbs_activities, Array

  #serialize :ten_latest_projects
  validates_presence_of :state
  validates  :title, :alias, :presence => true, :uniqueness => {case_sensitive: false}

  searchable do
    text :title, :description, :alias
  end

  #ASSM needs
  aasm :column => :state do  # defaults to aasm_state
    state :preliminary, :initial => true
    state :in_progress
    state :in_review
    state :private
    state :access_locked      ##locked
    state :baseline
    state :closed

    event :commit do
      transitions :to => :in_progress, :from => :preliminary
      transitions :to => :in_review, :from => :in_progress
      transitions :to => :baseline, :from => [:private, :in_review]
    end
  end

  amoeba do
    enable
    include_field [:pe_wbs_project, :pemodules, :groups, :users]

    customize(lambda { |original_project, new_project|
      new_project.title = "Copy_#{ original_project.copy_number.to_i+1} of #{original_project.title}"
      new_project.alias = "Copy_#{ original_project.copy_number.to_i+1} of #{original_project.alias}"
      new_project.copy_number = 0
      original_project.copy_number = original_project.copy_number.to_i+1
    })

    #prepend :title => "Copy of "
    propagate
  end

  def self.encoding
    ["Big5", "CP874", "CP932", "CP949", "gb18030", "ISO-8859-1", "ISO-8859-13", "ISO-8859-15", "ISO-8859-2", "ISO-8859-8", "ISO-8859-9", "UTF-8", "Windows-874"]
  end

  #Return possible states of project
  def states
    if self.preliminary? || self.in_progress? || self.in_review? || self.private?
      Project.aasm_states_for_select
    else
      Project.aasm_states_for_select.reject{|i| i[0] == "preliminary" || i[0] == "in_progress" || i[0] == "in_review" || i[0] == "private" }
    end
  end

  #Return the root pbs_project_element of the pe-wbs-project and consequetly of the project.
  def root_component
    self.pe_wbs_projects.wbs_product.first.pbs_project_elements.select{ |i| i.is_root = true}.first  unless self.pe_wbs_projects.wbs_product.first.nil?
    #PbsProjectElement.find_by_pe_wbs_project_id_and_is_root(self.pe_wbs_project.id, true)
  end

  def wbs_project_element_root
    self.pe_wbs_projects.wbs_activity.first.wbs_project_elements.select{ |i| i.is_root = true}.first  unless self.pe_wbs_projects.wbs_activity.first.nil?
  end

  #Override
  def to_s
    self.title + ' - ' + self.description.truncate(20)
  end

  #Return project value
  def project_value(attr)
    self.send(attr.project_value.gsub("_id", ''))
  end

  #Execute a set of module (commun or typed) in the order (user order). Recursive method.
  #TODO : move to Pemodule class
  def run_estimation_plan(input_data, level)
  #def run_estimation_plan(current_pos, arguments, last_result, c, project)

    #current_module_projects = ModuleProject.find_all_by_position_y_and_project_id(current_pos, self.id)
    #operations = current_module_projects.map{|j| j.pemodule}.reject{|i| !i.compliant_component_type.include?(c.work_element_type.alias)}
    #
    #next_current_module_projects = ModuleProject.find_all_by_position_y_and_project_id(current_pos+1, self.id)
    #next_operations = next_current_module_projects.map{|j| j.pemodule}.reject{|i| !i.compliant_component_type.include?(c.work_element_type.alias)}
    #
    #new_arguments = HashWithIndifferentAccess.new
    #
    #operations.map{|j| j.alias}.each_with_index do |my_op, index|
    #
    #  my_object =  "#{my_op.camelcase}::#{my_op.camelcase}".constantize.send(:new, arguments[my_op], project.id, current_pos, c.id, index)
    #  last_result[my_op.to_sym] = my_object.send(my_op)
    #
    #  next_operations.map{|j| j.alias}.each do |no|
    #    new_arguments[no] = last_result
    #  end
    #
    #end
    #
    #unless current_pos >= self.module_projects.map(&:position_y).max
    #  self.run_estimation_plan(current_pos+1, new_arguments, last_result, c, project)
    #else
    #  return last_result
    #end

    @result_array = Array.new
    @result_hash = Hash.new
    inputs = Hash.new

    self.module_projects.each do |module_project|

      module_project.module_project_attributes.each do |mpa|
        if mpa.input?
          inputs[mpa.attribute.alias.to_sym] = input_data[mpa.attribute.alias][module_project.id.to_s]
        end

        current_module = "#{module_project.pemodule}::#{module_project.pemodule}".constantize
        cm = current_module.send(:new, inputs)

        if mpa.output?
          @result_hash[mpa.attribute.alias.to_sym] = cm.send("get_#{mpa.attribute.alias}")
        end
      end

    end

    @result_hash
  end

  #Return folders list of a projects
  def folders
    self.pe_wbs_projects.wbs_product.first.pbs_project_elements.select{|i| i.folder? }
  end

  def self.table_search(search)
    if search
      where('title LIKE ? or alias LIKE ? or state LIKE ?', "%#{search}%","%#{search}%", "%#{search}%" )
    else
      scoped
    end
  end

end