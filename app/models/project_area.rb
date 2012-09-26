#ProjectArea management
class ProjectArea < ActiveRecord::Base
  has_and_belongs_to_many :activity_categories
  has_and_belongs_to_many :labor_categories
  has_and_belongs_to_many :platform_categories
  has_and_belongs_to_many :acquisition_categories
  has_and_belongs_to_many :project_categories
  belongs_to :project

  #Sunspot needs
  searchable do
    text :name, :description
  end

  #Override
  def to_s
    self.name
  end
end
