#WorkElementType has many components and belongs to project_area. WET can be "development", "cots" but also "folder" and "link"
class WorkElementType < ActiveRecord::Base
  has_many :components
  belongs_to :project_area

  #Sunspot needs
  searchable do
    text :name, :description, :alias
  end

  #Override
  def to_s
    self.name
  end
end
