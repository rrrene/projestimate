#Language of the User
class Language < ActiveRecord::Base
  has_many :users

  validates_presence_of :name
  validates_presence_of :locale

  #Return default locale
  #def self.default_locale
  #  return Language::find_by_locale("en")
  #end

  #Override
  def to_s
    self.name
  end

end
