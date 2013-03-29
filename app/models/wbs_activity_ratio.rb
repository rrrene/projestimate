#encoding: utf-8
class WbsActivityRatio < ActiveRecord::Base

  include MasterDataHelper

  has_many :wbs_activity_ratio_elements, :dependent => :destroy
  has_many :wbs_project_elements
  has_many :pbs_project_elements

  belongs_to :reference_value
  belongs_to :wbs_activity

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :custom_value, :presence => true, :if => :is_custom?
  validates :name, :presence => true, :uniqueness => { :scope => [:wbs_activity_id, :record_status_id], :case_sensitive => false}

  #Enable the amoeba gem for deep copy/clone (dup with associations)
  amoeba do
    enable
    include_field [:wbs_activity_ratio_elements]

    customize(lambda { |original_wbs_activity_ratio, new_wbs_activity_ratio|
      if defined?(MASTER_DATA) and MASTER_DATA and File.exists?("#{Rails.root}/config/initializers/master_data.rb")
        new_wbs_activity_ratio.record_status_id = RecordStatus.find_by_name("Proposed").id
      else
        new_wbs_activity_ratio.record_status_id = RecordStatus.find_by_name("Local").id
      end
      new_wbs_activity_ratio.copy_number = 0
      original_wbs_activity_ratio.copy_number = original_wbs_activity_ratio.copy_number.to_i+1
    })

    #propagate
  end

  def self.export(activity_ratio_id)
    activity_ratio = WbsActivityRatio.find(activity_ratio_id)
    csv_string = CSV.generate(:col_sep => I18n.t(:general_csv_separator)) do |csv|
      csv << ["id", "Ratio Name", "Outline", "Element Name", "Element Description", "Ratio Value", "Simple Reference", "Multiple References"]
      activity_ratio.wbs_activity_ratio_elements.each do |element|
        csv << [element.id, "#{activity_ratio.name}", "#{element.wbs_activity_element.dotted_id}", "#{element.wbs_activity_element.name}", "#{element.wbs_activity_element.description}", element.ratio_value, element.simple_reference, element.multiple_references]
      end
    end
    csv_string.encode(I18n.t(:general_csv_encoding))
  end

  def self.import(file, sep, encoding)
    sep = "#{sep.blank? ? I18n.t(:general_csv_separator) : sep}"
    error_count = 0
    CSV.open(file.path, "r", :quote_char => "\"", :row_sep => :auto, :col_sep => sep, :encoding => "#{encoding}:utf-8") do |csv|
      csv.each_with_index do |row, i|
        unless row.empty? or i == 0
          begin
            @ware = WbsActivityRatioElement.find(row[0])
            @ware.wbs_activity_element.has_children?
            @ware.update_attribute("ratio_value", row[5])
            @ware.update_attribute("simple_reference", row[6])
            @ware.update_attribute("multiple_references", row[7])
          rescue
            error_count = error_count + 1
          end
        end
      end
    end
    error_count
  end

  def is_One_Activity_Element?
    begin
      if self.reference_value.value==I18n.t(:one_activity_element)
        return true
      else
        return false
      end
    rescue
      return false
    end
  end

  def is_All_Activity_Elements?
    begin
      if self.reference_value.value==I18n.t(:all_activity_elements)
        return true
      else
        return false
      end
    rescue
      return false
    end
  end

  def is_A_Set_Of_Activity_Elements?
    begin
      if self.reference_value.value==I18n.t(:all_activity_elements)
        return true
      else
        return false
      end
    rescue
      return false
    end
  end
end
