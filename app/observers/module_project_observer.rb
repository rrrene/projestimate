class ModuleProjectObserver < ActiveRecord::Observer
  observe ModuleProject

  def before_destroy(module_project)
    attr_prj_ids = ModuleProjectAttribute.find_all_by_module_project_id(module_project.id).map(&:id).join(",")
    unless attr_prj_ids.blank?
      ModuleProjectAttribute.delete_all("id IN (#{attr_prj_ids})")
    end
  end

end
