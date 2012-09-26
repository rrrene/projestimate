class PermissionObserver < ActiveRecord::Observer
  observe Permission

  #def after_save(permission)
  #  permission.name = String.keep_clean_space(permission.name.to_s)
  #  permission.save
  #end

end