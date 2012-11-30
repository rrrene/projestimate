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

# User of the application. User has many projects, groups, permissions and project securities. User have one language
class User < ActiveRecord::Base
  include AASM

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :permissions
  has_and_belongs_to_many :organizations

  belongs_to :language
  belongs_to :auth_method, :foreign_key => "auth_type"

  has_many :project_securities

  attr_accessor :password, :password_confirmation

  serialize :ten_latest_projects, Array

  before_save :encrypt_password
  before_create { generate_token(:auth_token) }

  validates_presence_of :last_name, :first_name, :login_name, :email, :user_status, :auth_type
  validates :password, :confirmation => true

  #AASM
  aasm :column => :user_status do  # defaults to aasm_state
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
      where("email >= ? OR login_name < ?", login, login)
  }

  #return groups using for global permissions
  def group_for_global_permissions
    self.groups.select{ |i| i.for_global_permission ==  true }
  end

  #return groups using for project securities
  def group_for_project_securities
    self.groups.select{ |i| i.for_project_security ==  true }
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
    user = User.find(:first, :conditions => ["login_name = ? OR email = ?", login, login ])

    #if a user is found
    if user
      if user.auth_method.name != "Application"
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

    #ldap_mail = Net::LDAP.new(:host => self.auth_method.server_name,
    #                       :base => self.auth_method.base_dn,
    #                       :port => self.auth_method.port.to_i,
    #                       :encryption => use_ssl,
    #                       :auth => {
    #                           :method => :simple,
    #                           :username => "#{self.auth_method.mail_attribute.to_s}=#{user.email},#{self.auth_method.base_dn}",
    #                           :password => password
    #                       })
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

  #Override
  def to_s
    self.name
  end

  # Returns "Firtname Name"
  def name
    self.first_name + " " + self.last_name
  end

  #Return true if user is a Administrator
  def admin?
    self.roles.map(&:code_role).include?("ADMIN")
  end

  #Send email in order to reset user password
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    self.save!
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
      where('first_name LIKE ? or last_name LIKE ? or email LIKE ? or login_name LIKE ? or user_status LIKE ?', "%#{search}%","%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%" )
    else
      scoped
    end
  end

  #return the ten latest project
  #TODO: change name of field. Use latest_project instead of ten_latest_project
  def latest_project
    self.ten_latest_projects
  end

  #Load user project securioties for selected project id
  def project_securities_for_select(prj_id)
    self.project_securities.select{ |i| i.project_id == prj_id }.first
  end

  #Add in the list of latest project a new project
  def add_recent_project(project_id)
    self.ten_latest_projects = self.ten_latest_projects.push(project_id)
    self.ten_latest_projects = self.ten_latest_projects.uniq.reverse
    self.save
  end

  #Delete in the list of latest project a new project
  def delete_recent_project(project_id)
    self.ten_latest_projects = self.ten_latest_projects.pop(project_id)
    self.ten_latest_projects = self.ten_latest_projects.uniq.reverse
    self.save
  end

end
