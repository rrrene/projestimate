#encoding: utf-8
class WbsActivityRatio < ActiveRecord::Base

  include MasterDataHelper
  belongs_to :reference_value
  belongs_to :wbs_activity
  has_many :wbs_activity_ratio_elements, :dependent => :destroy

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true
  validates :custom_value, :presence => true, :if => :is_custom?
  validate :name_must_be_uniq_on_activity, :presence => true, :uniqueness => { :scope => :record_status_id, :case_sensitive => false}

  def name_must_be_uniq_on_activity
    #errors.add(:base, "Name must be unique in the same wbs-activities") if (self.wbs_activity.wbs_activity_ratios.map(&:name).include?(self.name)  )
    errors.add(:base, "Name must be unique in the same wbs-activities") if has_unique_field?
  end

  def has_unique_field?
    WbsActivityRatio.exists?(['name = ? and wbs_activity_id = ?', self.name, self.wbs_activity_id])
  end

  #Enable the amoeba gem for deep copy/clone (dup with associations)
  amoeba do
    enable
    include_field [:wbs_activity_ratio_elements]

    customize(lambda { |original_wbs_activity_ratio, new_wbs_activity_ratio|
      new_wbs_activity_ratio.copy_number = 0
      original_wbs_activity_ratio.copy_number = original_wbs_activity_ratio.copy_number.to_i+1
    })

    #propagate
  end

  def self.export(activity_ratio_id)
    activity_ratio = WbsActivityRatio.find(activity_ratio_id)
    csv_string = CSV.generate(:col_sep => I18n.t(:general_csv_separator)) do |csv|
      csv << ["id", "Ratio Name", "Outline", "Element Name", "Element Description", "Ratio Value", "Reference"]
      activity_ratio.wbs_activity_ratio_elements.each do |element|
        csv << [element.id, "#{activity_ratio.name}", "#{element.wbs_activity_element.dotted_id}", "#{element.wbs_activity_element.name}", "#{element.wbs_activity_element.description}", element.ratio_value, element.ratio_reference_element]
      end
    end
    csv_string
  end

  def self.import(file, sep, encoding)
    sep = "#{sep.blank? ? I18n.t(:general_csv_separator) : sep}"
    error_count = 0
    CSV.open(file.path, "r", :quote_char => "\"", :row_sep => :auto, :col_sep => sep, :encoding => "#{encoding}:utf-8") do |csv|
      csv.each_with_index do |row, i|
        unless row.empty? or i == 0
          begin
            ActiveRecord::Base.connection.execute("UPDATE wbs_activity_ratio_elements SET ratio_value = #{row[5]}, ratio_reference_element = #{row[6]} WHERE id = #{row[0]}")
          rescue
            error_count = error_count + 1
          end
        end
      end
    end
    error_count
  end

end
