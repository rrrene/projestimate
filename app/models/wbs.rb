#WBS has many component and belongs to project
class Wbs < ActiveRecord::Base
  has_many :components, :dependent => :destroy
  belongs_to :project
end
