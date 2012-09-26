class ProjectObserver < ActiveRecord::Observer
  observe Project

  #def after_create(project)
    #New default wbs
    #wbs = Wbs.new(:project => project)
    #wbs.save

    #New root component
    #component = Component.new(:is_root => true, :wbs_id => wbs.id, :work_element_type_id => default_work_element_type.id, :position => 0, :name => "Root folder")
    #component.save
  #end

  #def before_destroy(project)
    #project.users.each do |user|
    #  user.ten_latest_projects.delete(project.id)
    #  user.save
    #end
  #end

  #private
  #def default_work_element_type
  #  wet = WorkElementType.find_by_alias("folder")
  #  return wet
  #end

end