class AuthMethod < ActiveRecord::Base
  validates_presence_of :name, :server_name, :port, :base_dn, :certificate

  has_many :users, :foreign_key => "auth_type"

  def to_s
    self.name
  end
end
