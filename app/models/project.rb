#encoding: utf-8
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


class Project < ActiveRecord::Base
  include AASM
  include ActionView::Helpers
  include ActiveModel::Dirty

  #define_attribute_methods :state

  has_ancestry

  belongs_to :organization
  belongs_to :project_area
  belongs_to :acquisition_category
  belongs_to :platform_category
  belongs_to :project_category

  has_many :events
  has_many :module_projects, :dependent => :destroy
  has_many :pemodules, :through => :module_projects
  has_many :project_securities, :dependent => :destroy

  has_many :pe_wbs_projects, :dependent => :destroy
  has_many :pbs_project_elements, :through => :pe_wbs_projects
  has_many :wbs_project_elements, :through => :pe_wbs_projects

  has_and_belongs_to_many :groups
  has_and_belongs_to_many :users

  default_scope order('title ASC, version ASC')

  serialize :included_wbs_activities, Array

  #serialize :ten_latest_projects
  validates_presence_of :state
  validates :title, :presence => true
  validates :alias, :presence => true
  validates :version, :presence => true
  validate :check_title_alias_version

  #Search fields
  scoped_search :on => [:title, :alias, :description, :start_date, :created_at, :updated_at]
  scoped_search :in => :organization, :on => :name
  scoped_search :in => :pbs_project_elements, :on => :name
  scoped_search :in => :wbs_project_elements, :on => [:name, :description]

  #ASSM needs
  aasm :column => :state do # defaults to aasm_state
    state :preliminary, :initial => true
    state :in_progress
    state :in_review
    state :checkpoint
    state :released
    state :rejected

    event :commit do #promote project
      transitions :to => :in_progress, :from => :preliminary
      transitions :to => :in_review, :from => :in_progress
      transitions :to => :released, :from => :in_review
    end
  end

  amoeba do
    enable
    include_field [:pe_wbs_projects, :module_projects, :groups, :users, :project_securities]

    customize(lambda { |original_project, new_project|
      new_project.title = "Copy_#{ original_project.copy_number.to_i+1} of #{original_project.title}"
      new_project.alias = "Copy_#{ original_project.copy_number.to_i+1} of #{original_project.alias}"
      new_project.version = "1.0"
      new_project.description = " #{original_project.description} \n \n This project is a duplication of project \"#{original_project.title} (#{original_project.alias}) - #{original_project.version}\" "
      new_project.copy_number = 0
      new_project.is_model = false
      original_project.copy_number = original_project.copy_number.to_i+1
    })

    propagate
  end

  #Check the couples (title,version) and (alias,version) validation
  def check_title_alias_version
    begin
      project = Project.where('(title=? AND version=?) OR (alias=? AND version=?)', self.title, self.version, self.alias, self.version).first
      if project
        errors.add(:title, "the pairs 'name/version' and 'alias/version' must be unique")
        errors.add(:alias, "the pairs 'name/version' and 'alias/version' must be unique")
        errors.add(:version, "the pairs 'name/version' and 'alias/version' must be unique")
      end
    rescue
      errors.add(:title, "the pairs 'name/version' and 'alias/version' must be unique")
      errors.add(:alias, "the pairs 'name/version' and 'alias/version' must be unique")
      errors.add(:version, "the pairs 'name/version' and 'alias/version' must be unique")
    end
  end

  def self.encoding
    ['Big5', 'CP874', 'CP932', 'CP949', 'gb18030', 'ISO-8859-1', 'ISO-8859-13', 'ISO-8859-15', 'ISO-8859-2', 'ISO-8859-8', 'ISO-8859-9', 'UTF-8', 'Windows-874']
  end

  #Return possible states of project
  def states
    if self.preliminary? || self.in_progress? || self.in_review?
      Project.aasm_states_for_select
    else
      Project.aasm_states_for_select.reject { |i| i[0] == 'preliminary' || i[0] == 'in_progress' || i[0] == 'in_review'}
    end
  end

  #Return the root pbs_project_element of the pe-wbs-project and consequently of the project.
  def root_component
    self.pe_wbs_projects.products_wbs.first.pbs_project_elements.select { |i| i.is_root = true }.first unless self.pe_wbs_projects.products_wbs.first.nil?
  end

  def wbs_project_element_root
    self.pe_wbs_projects.activities_wbs.first.wbs_project_elements.select { |i| i.is_root = true }.first unless self.pe_wbs_projects.activities_wbs.first.nil?
  end

  #Override
  def to_s
    self.title + ' - ' + self.description.truncate(40)
  end

  #Return project value
  def project_value(attr)
    self.send(attr.project_value.gsub('_id', ''))
  end

  #Return folders of wbs product of a list of a projects
  def folders
    self.pe_wbs_projects.products_wbs.first.pbs_project_elements.select { |i| i.work_element_type.alias == 'folder' }
  end

  def self.table_search(search)
    if search
      where('title LIKE ? or alias LIKE ? or state LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

  #Estimation plan o project is locked or not?
  def locked?
    (self.is_locked.nil? or self.is_locked == true) ? true : false
  end

  def in_frozen_status?
    (self.state.in?(%w(rejected released checkpoint))) ? true : false
  end

end