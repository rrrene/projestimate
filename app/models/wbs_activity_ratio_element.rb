#encoding: utf-8
class WbsActivityRatioElement < ActiveRecord::Base

  include MasterDataHelper

  belongs_to :wbs_activity_ratio
  belongs_to :wbs_activity_element

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  #validates :ratio_value, :numericality => { :greater_than => 0, :less_than => 100 }

  #Enable the amoeba gem for deep copy/clone (dup with associations)
  amoeba do
    enable

    customize(lambda { |original_wbs_activity_ratio_elt, new_wbs_activity_ratio_elt|

      if defined?(MASTER_DATA) and MASTER_DATA and File.exists?("#{Rails.root}/config/initializers/master_data.rb")
        new_wbs_activity_ratio_elt.record_status_id = RecordStatus.find_by_name("Proposed").id
      else
        new_wbs_activity_ratio_elt.record_status_id = RecordStatus.find_by_name("Local").id
      end

    })

  end
end
