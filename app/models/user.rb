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
require 'active_directory'
class User < ActiveRecord::Base
  include AASM

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :permissions
  has_and_belongs_to_many :organizations

  belongs_to :language

  has_many :project_securities
  
  attr_accessor :password, :password_confirmation

  serialize :ten_latest_projects, Array

  #TODO : Switch to obeserver
  before_save :encrypt_password
  before_create { generate_token(:auth_token) }

  #TODO: MAke other validations
  validates_presence_of :surename, :first_name, :user_name

  #AASM
  aasm :column => :user_status do  # defaults to aasm_state
    state :active, :initial => true
    state :suspended
    state :blacklisted
    state :pending

    event :switch_to_suspended do
      transitions :to => :suspended, :from => [:active, :blacklisted, :pending]
    end

    event :switch_to_active do
      transitions :to => :active, :from => [:suspended, :blacklisted, :pending]
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
  def self.authenticate(username, password)
    #Search user from username
    user = User.find_by_user_name(username)
    if user
      if user.type_auth == "ldap"
        settings = {
          #  spirula.spirula.org
          :host => '192.168.1.150',
          :base => 'dc=spirula,dc=org',
          :port => 389,
          :auth => {
            :method => :simple,
            :username => username,
            :password => password
          }
        }
        #Setup ldap
        ActiveDirectory::Base.setup(settings)
        #TODO:bind connection with user/pwd
        unless ActiveDirectory::User.find(:all).empty?
          if user.active?
            user
          end
        else
          nil
        end
      else
        if user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt) && user.active?
          user
        else
          return nil
        end
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
    self.first_name + " " + self.surename
  end

  #Return true if user is a Administrator
  def admin?
    self.roles.map(&:code_role).include?("ADMIN")
  end

  #Send email in order to reset user password
  #TODO:Move into an observer
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

  #Search on first_name, surename, email, user_name fields.
  def self.search(search)
    if search
      where('first_name LIKE ? or surename LIKE ? or email LIKE ? or user_name LIKE ?', "%#{search}%","%#{search}%", "%#{search}%", "%#{search}%" )
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
