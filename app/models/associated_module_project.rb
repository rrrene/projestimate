class AssociatedModuleProject < ActiveRecord::Base
  belongs_to :module_project
  belongs_to :associated_module_project, :class_name => "ModuleProject"
end