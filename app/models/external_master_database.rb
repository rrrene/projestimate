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
    self.table_name = "acquisition_categories"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalActivityCategory < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "activity_categories"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalAttribute < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "attributes"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalAttributeModule < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "attributes_modules"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalCurrency < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "currencies"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalEventType < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "event_types"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalLaborCategory < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "labor_categories"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalLanguage < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "languages"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalMasterSetting < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "master_settings"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalPeicon < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "peicons"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalPemodule < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "pemodules"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalPlatformCategory < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "platform_categories"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalProjectArea < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "project_areas"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalProjectCategory < ActiveRecord::Base
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
    establish_connection HOST
    self.table_name = "project_categories"
  end

  class ExternalProjectSecurityLevel < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "project_security_levels"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalRecordStatus < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "record_status"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalWorkElementType < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "work_element_types"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalAdminSetting < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "admin_settings"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalAuthMethod < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "auth_methods"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalGroup < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "groups"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalPermission < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "permissions"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end

  class ExternalRecordStatus < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "record_statuses"
    scope :proposed, lambda {|cs| where("record_status_id = ?", cs) }
  end
end