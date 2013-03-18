  #encoding: utf-8
  class WbsActivityElement < ActiveRecord::Base
  include MasterDataHelper

  has_ancestry

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  belongs_to :wbs_activity
  has_many :wbs_activity_ratio_elements, :dependent => :destroy

  has_many :wbs_project_elements

  #for Estimation purpose
  ##has_many :ej_estimation_values

  #default_scope order("id asc")
  #default_scope order("dotted_id asc")
  scope :is_ok_for_validation, lambda {|de, re| where("record_status_id <> ? and record_status_id <> ?", de, re) }
  scope :elements_root, where(:is_root => true)

  validates :name, :presence => true, :uniqueness => { :scope => [:wbs_activity_id, :ancestry, :record_status_id], :case_sensitive => false}
  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :custom_value, :presence => true, :if => :is_custom?

  #Enable the amoeba gem for deep copy/clone (dup with associations)
  amoeba do
    enable

    exclude_field [:wbs_activity_ratio_elements]

    customize(lambda { |original_wbs_activity_elt, new_wbs_activity_elt|
      new_wbs_activity_elt.copy_id = original_wbs_activity_elt.id

      if defined?(MASTER_DATA) and MASTER_DATA and File.exists?("#{Rails.root}/config/initializers/master_data.rb")
        new_wbs_activity_elt.record_status_id = RecordStatus.find_by_name("Proposed").id
      else
        new_wbs_activity_elt.record_status_id = RecordStatus.find_by_name("Local").id
      end
    })

  end


  def wbs_activity_name
    self.wbs_activity.name
  end

  def self.import(file, sep)
    #find localstatus
    @localstatus = RecordStatus.find_by_name("Local")

    #create wbs_activity
    @wbs_activity = WbsActivity.new(:name => "#{file.original_filename} - #{Time.now.to_s}",
                                    :state => "draft",
                                    :record_status => @localstatus)
    @wbs_activity.save

    #create root element
    @root_element = WbsActivityElement.new(:name => @wbs_activity.name,
                                           :description => "The root element corresponds to the wbs activity.",
                                           :dotted_id => "0",
                                           :wbs_activity => @wbs_activity,
                                           :record_status => @localstatus,
                                           :parent => nil,
                                           :is_root => true)
    @root_element.save

    sep = "#{sep.blank? ? I18n.t(:general_csv_separator) : sep}"

    #for each row save in data base
    CSV.open(file.path, 'r', :encoding => 'ISO-8859-1:utf-8', :quote_char => "\"", :row_sep => :auto, :col_sep => sep ) do |csv|
      @inserts = []
      csv.each_with_index do |row, i|
        unless row.empty? or i == 0
          @inserts.push("(\"#{Time.now}\",
                          \"#{ !row[2].nil? ? row[2].gsub("\"", "\"\"") : row[2] }\",
                          \"#{ !row[0].nil? ? row[0].gsub("\"", "\"\"") : row[0] }\",
                          \"#{ !row[1].nil? ? row[1].gsub("\"", "\"\"") : row[1] }\", #{@localstatus.id}, #{@wbs_activity.id}, \"#{UUIDTools::UUID.timestamp_create.to_s}\")")

        end
      end
    end

    ActiveRecord::Base.connection.execute("INSERT INTO wbs_activity_elements(created_at,description,dotted_id,name,record_status_id,wbs_activity_id,uuid) VALUES  #{@inserts.join(",")}")

    elements = @wbs_activity.wbs_activity_elements
    build_ancestry(elements, @wbs_activity.id)

  end

  def self.build_ancestry(elements, activity_id)
    elements.each do |elt|
      ActiveRecord::Base.transaction do
        hierarchy = elt.dotted_id
        ancestors = []
        @root_element = WbsActivityElement.find_by_dotted_id_and_wbs_activity_id("0", activity_id)
        unless hierarchy == "0" or hierarchy.nil?
          idse = hierarchy.split(/^(.*)\.[^\.]*.$/).last
          if idse == hierarchy
            if @root_element
              elt.ancestry = @root_element.id
            end
          else
            pere = WbsActivityElement.find_by_dotted_id_and_wbs_activity_id(idse, activity_id)
            unless pere.nil?
              ancestors << pere.ancestry
              ancestors << pere.id
            end
            elt.ancestry = ancestors.join('/')
          end
          elt.save(:validate => false)
        end
      end
    end
  end

  def self.rebuild(elements, activity_id)
    elements.each do |elt|
      ancestors = []
      pere = WbsActivityElement.find_by_wbs_activity_id(activity_id)
      unless pere.nil?
        ancestors << pere.ancestry
        ancestors << pere.id
      end
      elt.ancestry = ancestors.join('/')
      elt.save(:validate => false)
    end
  end
end
