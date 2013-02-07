  #encoding: utf-8
  class WbsActivityElement < ActiveRecord::Base
  include MasterDataHelper

  has_ancestry

  #attr_accessible :ancestry, :description, :name, :uuid, :wbs_activity_id

  belongs_to :record_status
  belongs_to :owner_of_change, :class_name => "User", :foreign_key => "owner_id"

  belongs_to :wbs_activity

  validates :uuid, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true, :uniqueness => { :scope => :record_status_id, :case_sensitive => false}, :unless => :check_reference
  validates :wbs_activity_id, :presence => true
  validates :custom_value, :presence => true, :if => :is_custom?

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
    CSV.open(file.path, :encoding => 'ISO-8859-1:utf-8', :quote_char => '"', :row_sep => :auto, :headers => false) do |csv|
      @inserts = []

      csv.each do |row|
        array = row.first.split(";").flatten
        @inserts.push "('#{Time.now}', \"#{array[2]}\", '#{array[0]}', \"#{array[1]}\", #{@localstatus.id}, #{@wbs_activity.id})"
      end
    end

    ActiveRecord::Base.connection.execute("INSERT INTO wbs_activity_elements(created_at,description,dotted_id,name,record_status_id,wbs_activity_id) VALUES #{@inserts.join(",")}")

    elements = @wbs_activity.wbs_activity_elements
    build_ancestry(elements)

  end

  def self.build_ancestry(elements)

    root_element_id = WbsActivityElement.find_by_dotted_id("0").id

    elements.each do |elt|
      hierarchy = elt.dotted_id
      ancestors = []
      unless hierarchy == "0"
        idse = hierarchy.split(/^(.*)\.[^\.]*.$/).last
        if idse == hierarchy
          elt.ancestry = root_element_id
        else
          pere = WbsActivityElement.find_by_dotted_id(idse)
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
