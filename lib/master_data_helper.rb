require "rubygems"
require "uuidtools"

module MasterDataHelper

  def self.included(base)

    base.class_eval do
      #UUID generation on create
      #before_validation :set_uuid
      #TODO: validate uuid format and length in model
      before_validation(:on => :create) do
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

      #Retired method for record Retired status
      define_method(:is_retired?) do
        begin
          (self.record_status.name == "Retired") ? true : false
        rescue
          false
        end
      end

      # If record status id defined or nil
      define_method(:is_defined_or_nil?) do
        begin
          ( (self.record_status.name == "Defined") || (self.record_status.nil?) ) ? true : false
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

      #Draft record status
      define_method(:is_draft?) do
        begin
          (self.record_status.name == "Draft") ? true : false
        rescue
          false
        end
      end

      #InReview record status
      define_method(:is_inReview?) do
        begin
          (self.record_status.name == "InReview") ? true : false
        rescue
          false
        end
      end


      #Allow to show or not the record custom value (only if record_status = Custom) on List
      def show_custom_value
        if self.is_custom?
          "( #{self.custom_value} ) "
        end
      end
    end

    #Show record status collection list according to current_user permission
    def record_status_collection
      @record_statuses = RecordStatus.all
      begin

        if self.new_record?
          @record_statuses = RecordStatus.where("name = ?", "Proposed")
        else
          @record_statuses = RecordStatus.where("name <> ?", "Defined")
        end
      rescue
        nil
      end
    end

  end #END self.included

end