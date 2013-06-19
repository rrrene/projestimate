class AttributeOrganization < ActiveRecord::Base
  attr_accessible :is_mandatory, :pe_attribute_id

  belongs_to :pe_attribute, :class_name => "PeAttribute", :foreign_key => "pe_attribute_id"
  belongs_to :organization

  validates_presence_of :pe_attribute_id

end
