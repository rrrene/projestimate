class ModuleProject < ActiveRecord::Base
  belongs_to :pemodule
  belongs_to :project
  has_many :module_project_attributes

  #Return in a array next module project of self.
  def next
    pos = self.position_y.to_i
    mps = ModuleProject.where(:position_y => (pos + 1),:project_id => self.project.id)
    mps
  end

  #Return in a array previous module project of self.
  def previous
    pos = self.position_y.to_i
    mps = ModuleProject.where(:position_y => (pos - 1),:project_id => self.project.id)
    mps
  end

  #Define if two module of project linked between them.
  def is_linked_to?(mp, component_id)
    self.module_project_attributes.each do |mpa|
      while !(mpa.links.empty?) do
        return true
      end
    end
    return false
  end

  #Return the list of attributes that two modules of the project linked between them.
  def liaison(mp, component_id)
    self.module_project_attributes.each do |i|
      while !(i.links.empty?) do
        return i.links.first
      end
    end
    return []
  end

  def compatible_with(wet_alias)
    self.pemodule.compliant_component_type.include?(wet_alias)
  end

  def to_s
  self.pemodule.title
  end

end
