require "rubygems"
require "uuidtools"

module MasterDataHelper

  def self.included(base)
    base.class_eval do
      #UUID generation on create
      before_validation :set_uuid

      def set_uuid
        self.uuid = UUIDTools::UUID.timestamp_create.to_s   #generate uuid like: 4f844456-42bb-11e2-bebb-d4bed96c8c48"
      end

      #Enable the amoeba gem for deep copy/clone (dup with associations)
      amoeba do
        enable
        customize(lambda { |original_record, new_record|
          new_record.ref = original_record.uuid
          new_record.parent = original_record
          new_record.record_status = RecordStatus.first
        })
      end

      #Define method for record status
      define_method(:is_proposed?) do
        begin
          (self.record_status.name == "Proposed") ? true : false
        rescue
          false
        end
      end

      #Define method for record Defined status
      define_method(:is_defined?) do
        begin
          (self.record_status.name == "Defined") ? true : false
        rescue
          false
        end
      end

      #Custom record status
      define_method(:is_custom?) do
        begin
          (self.record_status.name == "Custom") ? true : false
        rescue
          false
        end
      end

    end
  end
end