#encoding: utf-8
class WbsActivityRatio < ActiveRecord::Base

  include MasterDataHelper

  belongs_to :wbs_activity
  has_many :wbs_activity_ratio_elements, :dependent => :destroy

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true, :uniqueness => { :scope => :record_status_id, :case_sensitive => false}
  validates :custom_value, :presence => true, :if => :is_custom?

  #Enable the amoeba gem for deep copy/clone (dup with associations)
  amoeba do
    enable

    customize(lambda { |original_wbs_activity_ratio, new_wbs_activity_ratio|

      new_wbs_activity_ratio.name = "Copy_#{ original_wbs_activity_ratio.copy_number.to_i+1} of #{original_wbs_activity_ratio.name}"

      new_wbs_activity_ratio.copy_number = 0
      original_wbs_activity_ratio.copy_number = original_wbs_activity_ratio.copy_number.to_i+1
    })

    propagate
  end

  def self.export(activity_ratio_id)
    activity_ratio = WbsActivityRatio.find(activity_ratio_id)
    CSV.open("#{activity_ratio.name}.csv", "w") do |csv|
      csv << ["id", "Name", "Description" "Ratio Value"]
      activity_ratio.wbs_activity_ratio_elements.each do |element|
        csv << [activity_ratio_id, "#{element.wbs_activity_element.name}", "#{element.wbs_activity_element.description}", element.ratio_value]
      end
    end
  end

  def self.import(file, sep)
    sep = "#{sep.blank? ? ';' : sep}"
    CSV.open(file.path, "r", :quote_char => "\"", :row_sep => :auto, :col_sep => sep) do |csv|
      csv.each_with_index do |row, i|
        unless row.empty? or i == 0
          begin
            ActiveRecord::Base.connection.execute("UPDATE wbs_activity_ratio_elements SET ratio_value = #{row[3]} WHERE id = #{row[0]}")
          rescue
            puts "#{i} problem(s)"
          end
        end
      end
    end


  end

end
