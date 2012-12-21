#Special table
class AuthMethod < ActiveRecord::Base
  include MasterDataHelper  #Module master data management (UUID generation, deep clone, ...)

  validates_presence_of :name, :server_name, :port, :base_dn

  has_many :users, :foreign_key => "auth_type"

  #self relation on master data : Parent<->Child
  has_one    :child,  :class_name => "AuthMethod", :inverse_of => :parent, :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "AuthMethod", :inverse_of => :child,  :foreign_key => "parent_id"

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  def to_s
    self.name
  end
end
