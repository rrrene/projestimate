module ExternalInclude

  def self.included(base)

    base.class_eval do
      unless base.to_s == "ExternalInclude:Module"
        has_one    :child_reference,  :class_name => "#{base}", :inverse_of => :parent_reference, :foreign_key => "reference_id"
        belongs_to :parent_reference, :class_name => "#{base}", :inverse_of => :child_reference,  :foreign_key => "reference_id"

        current_table_name = base.to_s
        current_table_name1 =  current_table_name.gsub!("ExternalMasterDatabase::", "")
        current_table_name2 =  current_table_name1.gsub!("External", "")
        base.table_name = current_table_name2.tableize
        scope :defined, lambda {|de| where("record_status_id = ?", de) }     #scope :custom_defined, lambda {|de, cu| where("record_status_id = ? or record_status_id = ?", de, cu) }

      end
    end

  end
end


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

  class ExternalReferenceValue < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalWbsActivityRatioElement < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalWbsActivityRatio < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalWbsActivity < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalWbsActivityElement < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalSchemaMigration < ActiveRecord::Base
    establish_connection HOST
    self.table_name = "schema_migrations"
  end

  class ExternalAcquisitionCategory < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalActivityCategory < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalPeAttribute < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalAttributeModule < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalCurrency < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalEventType < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalLaborCategory < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalLanguage < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalMasterSetting < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalPeicon < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalPemodule < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalPlatformCategory < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalProjectArea < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalProjectCategory < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalProjectSecurityLevel < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalRecordStatus < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalWorkElementType < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalAdminSetting < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalAuthMethod < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalGroup < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalPermission < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end

  class ExternalRecordStatus < ActiveRecord::Base
    establish_connection HOST
    include ExternalInclude
  end
end