  #encoding: utf-8
  class WbsActivityElement < ActiveRecord::Base
  include MasterDataHelper

  has_ancestry

  #attr_accessible :ancestry, :description, :name, :uuid, :wbs_activity_id

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  belongs_to :wbs_activity

  has_many :wbs_project_elements

  scope :is_ok_for_validation, lambda {|de, re, loc| where("record_status_id <> ? and record_status_id <> ? and record_status_id <> ?", de, re, loc) }

  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
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

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |element|
        csv << element.attributes.values_at(*column_names)
      end
    end
  end


  def self.import(file)
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
                                           :parent => nil)
    @root_element.save

    #for each row save in data base
    CSV.open(file.path, 'r', :encoding => 'ISO-8859-1:utf-8', :quote_char => "\"", :row_sep => :auto, :col_sep => ";" ) do |csv|
      @inserts = []
      csv.each_with_index do |row, i|
        unless row.empty? or i == 0
          @inserts.push("(\"#{Time.now}\", \"#{row[2]}\", \"#{row[0]}\", \"#{row[1].gsub("\"", "\"\"")}\", #{@localstatus.id}, #{@wbs_activity.id})")
        end
      end
    end

    ActiveRecord::Base.connection.execute("INSERT INTO wbs_activity_elements(created_at,description,dotted_id,name,record_status_id,wbs_activity_id) VALUES #{@inserts.join(",")}")

    elements = @wbs_activity.wbs_activity_elements
    build_ancestry(elements, @wbs_activity.id)

  end

  def self.build_ancestry(elements, activity_id)
    elements.each do |elt|
      ActiveRecord::Base.transaction do
        hierarchy = elt.dotted_id
        ancestors = []
        @root_element_id = WbsActivityElement.find_by_dotted_id_and_wbs_activity_id("0", activity_id).id
        unless hierarchy == "0"
          idse = hierarchy.split(/^(.*)\.[^\.]*.$/).last
          if idse == hierarchy
            elt.ancestry = @root_element_id
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
