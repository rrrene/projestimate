class WbsActivityElement < ActiveRecord::Base
  include MasterDataHelper

  has_ancestry

  #attr_accessible :ancestry, :description, :name, :uuid, :wbs_activity_id

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  belongs_to :wbs_activity

  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  #validates :name, :presence => true, :uniqueness => { :scope => :record_status_id, :case_sensitive => false}, :unless => :check_reference

  validate  :wbs_activity, :presence => true
  validates :custom_value, :presence => true, :if => :is_custom?

  validate :name_must_be_uniq_on_node, :presence => true, :uniqueness => { :scope => :record_status_id, :case_sensitive => false}
  def name_must_be_uniq_on_node
    if self.wbs_activity and self.parent
      #if self.siblings.map(&:name).include?(self.name)
        errors.add(:base, "Name must be unique in the same Node") if (has_unique_field? && self.siblings.map(&:name).include?(self.name)  )
      #end
    end
  end

  def has_unique_field?
    WbsActivityElement.exists?(['name = ? and record_status_id = ? and ancestry = ?', self.name, self.record_status_id, self.ancestry])
  end

  #Enable the amoeba gem for deep copy/clone (dup with associations)
  amoeba do
    enable

    customize(lambda { |original_wbs_activity_elt, new_wbs_activity_elt|
      new_wbs_activity_elt.reference_uuid = original_wbs_activity_elt.uuid
      new_wbs_activity_elt.reference_id = original_wbs_activity_elt.id

      new_wbs_activity_elt.copy_id = original_wbs_activity_elt.id
      new_wbs_activity_elt.name = "Copy_#{ original_wbs_activity_elt.wbs_activity.copy_number.to_i+1} of #{original_wbs_activity_elt.name}"
    })
  end


  def wbs_activity_name
    name
  end

  def check_reference
    if self.wbs_activity and self.parent
      !self.siblings.map(&:name).include?(self.name)
    else
      true
    end
  end

end
