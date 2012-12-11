require "rubygems"
require "uuidtools"

#Module for UUID generation (for Master Data Tables)
module UUIDHelper
  def self.included(base)
    base.class_eval do
      before_create :set_uuid

      def set_uuid
        self.uuid = UUIDTools::UUID.timestamp_create.to_s   #generate uuid like: 4f844456-42bb-11e2-bebb-d4bed96c8c48"
      end
    end
  end
end