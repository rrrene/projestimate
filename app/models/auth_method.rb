class AuthMethod < ActiveRecord::Base
  validates_presence_of :name, :server_url, :port, :base_dn, :certificate

  has_many :users, :foreign_key => "auth_type"

  def to_s
    if self.name == "app"
       "Applicatif"
    else
      self.name
    end
  end
end
