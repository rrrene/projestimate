#Organization of the User
class Organization < ActiveRecord::Base

  has_and_belongs_to_many :users

  #Override
  def to_s
    self.name
  end
end
