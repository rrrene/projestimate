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

  end

  class ExternalActivityCategory < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "activity_categories"

  end

  class ExternalAttribute < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "attributes"

  end

  class ExternalAttributeModule < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "attributes_modules"

  end

  class ExternalCurrency < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "currencies"

  end

  class ExternalEventType < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "event_types"

  end

  class ExternalLaborCategory < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "labor_categories"

  end

  class ExternalLanguage < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "languages"

  end

  class ExternalMasterSetting < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "master_settings"

  end

  class ExternalPeicon < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "peicons"

  end

  class ExternalPemodule < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "pemodules"

  end

  class ExternalPlatformCategory < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "platform_categories"

  end

  class ExternalProjectArea < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "project_areas"

  end

  class ExternalProjectCategory < ActiveRecord::Base

    establish_connection HOST
    self.table_name = "project_categories"
  end

  class ExternalProjectSecurityLevel < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "project_security_levels"

  end

  class ExternalRecordStatus < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "record_status"

  end

  class ExternalWorkElementType < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "work_element_types"

  end

  class ExternalAdminSetting < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "admin_settings"

  end

  class ExternalAuthMethod < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "auth_methods"

  end

  class ExternalGroup < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "groups"

  end

  class ExternalPermission < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "permissions"

  end

  class ExternalRecordStatus < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "record_statuses"

  end
end