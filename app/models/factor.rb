class Factor < ActiveRecord::Base
  attr_accessible :alias, :description, :name, :state

  has_many :organization_uow_complexities, :dependent => :destroy
end
