#encoding: utf-8
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

  has_one :wbs, :dependent => :destroy

  has_and_belongs_to_many :groups
  has_and_belongs_to_many :users

  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :state
  validates_presence_of :start_date

  searchable do
    text :title, :description, :alias
  end

  #ASSM needs
  aasm :column => :state do  # defaults to aasm_state
    state :preliminary, :initial => true
    state :in_progress
    state :in_review
    state :private
    state :locked
    state :baseline
    state :closed

    event :commit do
      transitions :to => :in_progress, :from => :preliminary
      transitions :to => :in_review, :from => :in_progress
      transitions :to => :baseline, :from => [:private, :in_review]
    end

  end

  #Return possible states of project
  def states
    if self.preliminary? || self.in_progress? || self.in_review? || self.private?
      Project.aasm_states_for_select
    else
      Project.aasm_states_for_select.reject{|i| i[0] == "preliminary" || i[0] == "in_progress" || i[0] == "in_review" || i[0] == "private" }
    end
  end

  #Return the root component of the wbs and consequetly of the project.
  def root_component
    Component.find_by_wbs_id_and_is_root(self.wbs.id, true)
  end

  #Verbose processus
  def processus
    self.module_projects.sort_by(&:position_y).map{|i| i.pemodule.title}.join(' >> ')
  end

  #Override
  def to_s
    self.title + ' - ' + self.description.truncate(20)
  end

  #return project value
  #Very ugly !
  def project_value(attr)
    self.send(attr.project_value.gsub("_id", ''))
  end

  #Execute a set of module (commun or typed) in the order (user order). Recursive method.
  #TODO : move to Pemodule class
  def run_estimation_plan(current_pos, arguments, last_result, c, project)

    current_module_projects = ModuleProject.find_all_by_position_y_and_project_id(current_pos, self.id)
    operations = current_module_projects.map{|j| j.pemodule}.reject{|i| !i.compliant_component_type.include?(c.work_element_type.alias)}

    next_current_module_projects = ModuleProject.find_all_by_position_y_and_project_id(current_pos+1, self.id)
    next_operations = next_current_module_projects.map{|j| j.pemodule}.reject{|i| !i.compliant_component_type.include?(c.work_element_type.alias)}

    new_arguments = HashWithIndifferentAccess.new

    operations.map{|j| j.alias}.each_with_index do |my_op, index|

      my_object =  "#{my_op.camelcase}::#{my_op.camelcase}".constantize.send(:new, arguments[my_op], project.id, current_pos, c.id, index)
      last_result[my_op.to_sym] = my_object.send(my_op)

      next_operations.map{|j| j.alias}.each do |no|
        new_arguments[no] = last_result
      end

    end

    unless current_pos >= self.module_projects.map(&:position_y).max
      self.run_estimation_plan(current_pos+1, new_arguments, last_result, c, project)
    else
      return last_result
    end
  end

  #Return folders list of a projects
  def folders
    self.wbs.components.select{|i| i.folder? }
  end

  #Generate a estimation plan
  #TODO:Switch into a helpers !
  #def generate_estimation_flow
  #  tot = []
  #  res = []
  #  self.module_projects.each do |mp|
  #    mp.next.each do |i|
  #      #if mp.is_linked_to?(i)
  #      #  res << mp.pemodule.alias
  #      #end
  #    end
  #  end
  #  return res
  #end

  #Generate an error ()build error) during building of estimation plan
  def self.build_error
    raise "A build error has been detected. Please verify the integrity of your estimation process."
  end

end