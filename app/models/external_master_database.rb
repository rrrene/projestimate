module ExternalMasterDatabase

  HOST = {
      :adapter => "mysql2",
      :database => "projestimate_MasterData",
      :reconnect => false,
      :host => "ns305372.ovh.net",
      :port => 3306,
      :username => "MasterData",
      :password => "MasterData",
      :encoding => "utf8"
  }


  class ExternalAcquisitionCategory < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalAcquisitionCategory", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalAcquisitionCategory", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "acquisition_categories"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalActivityCategory < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalActivityCategory", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalActivityCategory", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "activity_categories"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalAttribute < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalAttribute", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalAttribute", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "attributes"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalAttributeModule < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalAttributeModule", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalAttributeModule", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "attributes_modules"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalCurrency < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalCurrency", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalCurrency", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "currencies"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalEventType < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalEventType", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalEventType", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "event_types"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalLaborCategory < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalLaborCategory", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalLaborCategory", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "labor_categories"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalLanguage < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalLanguage", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalLanguage", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "languages"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalMasterSetting < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalMasterSetting", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalMasterSetting", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "master_settings"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalPeicon < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalPeicon", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalPeicon", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "peicons"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalPemodule < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalPemodule", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalPemodule", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "pemodules"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalPlatformCategory < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalPlatformCategory", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalPlatformCategory", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "platform_categories"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalProjectArea < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalProjectArea", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalProjectArea", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "project_areas"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalProjectCategory < ActiveRecord::Base
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalProjectCategory", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalProjectCategory", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "project_categories"
  end

  class ExternalProjectSecurityLevel < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalProjectSecurityLevel", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalProjectSecurityLevel", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "project_security_levels"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalRecordStatus < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalRecordStatus", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalRecordStatus", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "record_status"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalWorkElementType < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalWorkElementType", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalWorkElementType", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "work_element_types"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalAdminSetting < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalAdminSetting", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalAdminSetting", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "admin_settings"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalAuthMethod < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalAuthMethod", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalAuthMethod", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "auth_methods"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalGroup < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalGroup", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalGroup", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "groups"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalPermission < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalPermission", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalPermission", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "permissions"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalRecordStatus < ActiveRecord::Base
    establish_connection HOST
    has_one    :child,  :class_name => "ExternalRecordStatus", :inverse_of => :parent, :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "ExternalRecordStatus", :inverse_of => :child,  :foreign_key => "parent_id"
    self.table_name = "record_statuses"
    scope :defined, lambda {|cs| where("record_status_id = ?", cs) }
  end
end