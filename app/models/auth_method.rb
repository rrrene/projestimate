#Special table
class AuthMethod < ActiveRecord::Base
  include MasterDataHelper  #Module master data management (UUID generation, deep clone, ...)

  has_many :users, :foreign_key => "auth_type"

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates_presence_of :server_name, :port, :base_dn, :record_status
  validates :uuid, :presence => true, :uniqueness => { :case_sensitive => false }
  validates :name, :presence => true, :uniqueness => { :case_sensitive => false, :scope => :record_status_id }
  validates :custom_value, :presence => true, :if => :is_custom?

  amoeba do
    enable
    exclude_field [:users]

    customize(lambda { |original_record, new_record|
      new_record.reference_uuid = original_record.uuid
      new_record.reference_id = original_record.id
      new_record.record_status = RecordStatus.find_by_name("Proposed")
    })
  end

  def to_s
    self.name
  end
end
