class Message < ActiveRecord::Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :type, :description
  validates_presence_of :name
  validates_presence_of :type
  validates_length_of :description, :maximum => 500

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end