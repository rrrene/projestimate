#Group class contains some User.
class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :projects

  has_many :project_securities

  has_and_belongs_to_many :permissions

  #Override
  def to_s
    self.name
  end

  #Return group project securities for selected project_id
  def project_securities_for_select(prj_id)
    self.project_securities.select{ |i| i.project_id == prj_id }.first
  end

end
