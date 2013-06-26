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

require 'net/ldap'

# User of the application. User has many projects, groups, permissions and project securities. User have one language
class User < ActiveRecord::Base
  include AASM

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :permissions
  has_and_belongs_to_many :organizations

  belongs_to :language, :foreign_key => 'language_id', :touch => true
  belongs_to :auth_method, :foreign_key => 'auth_type', :touch => true

  has_many :project_securities
  has_many :authors, :foreign_key => 'author_id', :class_name => 'WbsProjectElement'

  #Master and Special Data Tables
  has_many :change_on_acquisition_categories, :foreign_key => 'owner_id', :class_name => 'AcquisitionCategory'
  has_many :change_on_activity_categories, :foreign_key => 'owner_id', :class_name => 'AcquisitionCategory'
  has_many :change_on_attributes, :foreign_key => 'owner_id', :class_name => 'PeAttribute'
  has_many :change_on_attribute_modules, :foreign_key => 'owner_id', :class_name => 'AttributeModule'
  has_many :change_on_currencies, :foreign_key => 'owner_id', :class_name => 'Currency'
  has_many :change_on_event_types, :foreign_key => 'owner_id', :class_name => 'EventType'
  has_many :change_on_labor_categories, :foreign_key => 'owner_id', :class_name => 'LaborCategory'
  has_many :change_on_languages, :foreign_key => 'owner_id', :class_name => 'Language'
  has_many :change_on_master_settings, :foreign_key => 'owner_id', :class_name => 'MasterSetting'
  has_many :change_on_peicons, :foreign_key => 'owner_id', :class_name => 'Peicon'
  has_many :change_on_pemodules, :foreign_key => 'owner_id', :class_name => 'Pemodule'
  has_many :change_on_platform_categories, :foreign_key => 'owner_id', :class_name => 'PlatformCategory'
  has_many :change_on_project_areas, :foreign_key => 'owner_id', :class_name => 'ProjectArea'
  has_many :change_on_project_categories, :foreign_key => 'owner_id', :class_name => 'ProjectCategory'
  has_many :change_on_project_security_levels, :foreign_key => 'owner_id', :class_name => 'ProjectSecurityLevel'
  has_many :change_on_record_statuses, :foreign_key => 'owner_id', :class_name => 'RecordStatus'
  has_many :change_on_work_element_types, :foreign_key => 'owner_id', :class_name => 'WorkElementType'

  has_many :change_on_admin_settings, :foreign_key => 'owner_id', :class_name => 'AdminSetting'
  has_many :change_on_auth_methods, :foreign_key => 'owner_id', :class_name => 'AuthMethod'
  has_many :change_on_groups, :foreign_key => 'owner_id', :class_name => 'Group'
  has_many :change_on_permissions, :foreign_key => 'owner_id', :class_name => 'Permission'

  attr_accessor :password, :password_confirmation

  serialize :ten_latest_projects, Array

  before_save :encrypt_password
  before_create { generate_token(:auth_token) }

  validates_presence_of :last_name, :first_name, :user_status, :auth_type
  validates :login_name, :presence => true, :uniqueness => {case_sensitive: false}
  validates :email, :presence => true, :format => {:with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/i}, :uniqueness => {case_sensitive: false}

  validates :password, :presence => {:on => :create}, :confirmation => true, :if => 'auth_method_application'
  validates :password_confirmation, :presence => {:on => :create}, :if => 'auth_method_application'
  validate :password_length, :on => :create, :if => 'password.present?'

  #AASM
  aasm :column => :user_status do
    state :active
    state :suspended
    state :blacklisted
    state :pending, :initial => true

    event :switch_to_suspended do
      transitions :to => :suspended, :from => [:active, :blacklisted, :pending]
    end

    event :switch_to_active do
      transitions :to => :active, :from => [:suspended, :blacklisted, :pending, :active]
    end

    event :switch_to_blacklisted do
      transitions :to => :blacklisted, :from => [:suspended, :active, :pending]
    end

    event :switch_to_blacklisted do
      transitions :to => :blacklisted, :from => [:suspended, :active, :pending]
    end

    event :switch_to_pending do
      transitions :to => :pending, :from => [:suspended, :active, :blacklisted]
    end
  end

  scope :exists, lambda { |login|
    where('email >= ? OR login_name < ?', login, login)
  }

  def auth_method_application
     self.auth_method.name=="Application"
  end

  #Check password minimum length value
  def password_length
    begin
      password_length = default_password_length = 4
      user_as = AdminSetting.find_by_key('password_min_length')
      if !user_as.nil?
        password_length = user_as.value.to_i
      end
      password_length
    rescue
      password_length
    end
    if self.password.length < password_length
      errors.add(:password, "password is too short (minimum is #{password_length} characters)")
    end

  end

  #return groups using for global permissions
  def group_for_global_permissions
    self.groups.select { |i| i.for_global_permission == true }
  end

  #return groups using for project securities
  def group_for_project_securities
    self.groups.select { |i| i.for_project_security == true }
  end

  # Allow to encrypt password
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  # Allow to identify the user before the connection.
  def self.authenticate(login, password)
    #login can be login_name or email
    user = User.find(:first, :conditions => ['login_name = ? OR email = ?', login, login])

    #if a user is found
    if user
      if user.auth_method.name != 'Application'
        begin
          user.ldap_authentication(password, login)
        rescue
          nil
        end
      else
        if user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt) && user.active?
          user
        else
          nil
        end
      end
    else
      nil
    end
  end

  def ldap_authentication(password, login)
    self.auth_method.certificate ? use_ssl=:simple_tls : ''
    ldap_cn = Net::LDAP.new(:host => self.auth_method.server_name,
                            :base => self.auth_method.base_dn,
                            :port => self.auth_method.port.to_i,
                            :encryption => use_ssl,
                            :auth => {
                                :method => :simple,
                                :username => "#{self.auth_method.user_name_attribute.to_s}=#{self.login_name.to_s},#{self.auth_method.base_dn}",
                                :password => password
                            })
    if ldap_cn.bind
      if self.active?
        self
      else
        nil
      end
    else
      nil
    end
  end

  #Check if password is present
  def password_present?
    !password.blank?
  end

  #Override
  def to_s
    self.name
  end

  # Returns "First Name"
  def name
    self.first_name + ' ' + self.last_name
  end

  #Send email in order to reset user password
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    self.save(:validate => false)
    UserMailer.forgotten_password(self).deliver
  end

  #Generate a token field
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  #Search on first_name, last_name, email, login_name fields.
  def self.table_search(search)
    if search
      where('first_name LIKE ? or last_name LIKE ? or email LIKE ? or login_name LIKE ? or user_status LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

  #return the ten latest project
  #TODO: change name of field. Use latest_project instead of ten_latest_project
  def latest_project
    self.ten_latest_projects
  end

  #Load user project securities for selected project id
  def project_securities_for_select(prj_id)
    self.project_securities.select { |i| i.project_id == prj_id }.first
  end

  #Add in the list of latest project a new project
  def add_recent_project(project_id)
    val = self.ten_latest_projects.delete(project_id.to_i)
    if val
      self.ten_latest_projects.insert(0, val.to_i)
    else
      self.ten_latest_projects.insert(0, project_id.to_i)
    end
    self.save
  end

  #Delete in the list of latest project a new project
  def delete_recent_project(project_id)
    self.ten_latest_projects.delete(project_id.to_i) if self.ten_latest_projects.include?(project_id.to_i)
    self.save
  end

  #List of Admin group
  def admin_groups
    Group.find_all_by_name(['Admin', 'MasterAdmin'])
  end

  def tz
    self.time_zone.nil? ? 'UTC' : self.time_zone
  end

  def locale
    begin
      self.language.locale.downcase
    rescue
      :en
    end

  end

end
