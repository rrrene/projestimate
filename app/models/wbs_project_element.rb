class WbsProjectElement < ActiveRecord::Base

  #attr_accessible :additional_description, :ancestry, :description, :exclude, :name, :author_id, :wbs_activity_element_id, :wbs_activity_id

  has_ancestry

  belongs_to :pe_wbs_project
  belongs_to :wbs_activity_element
  belongs_to :wbs_activity
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"

  scope :elements_root, where(:is_root => true)

  validates :name, :presence => true, :uniqueness => {:scope => :ancestry, :case_sensitive => false}

  #validate :name_must_be_uniq_on_node, :presence => true, :uniqueness => { :case_sensitive => false }
  #def name_must_be_uniq_on_node
  #  if self.wbs_activity and self.parent
  #    errors.add(:base, "Name must be unique in the same Node") if has_unique_name?
  #  end
  #end

  def has_unique_name?
    WbsProjectElement.exists?(['name = ? and ancestry = ?', self.name, self.ancestry])
  end

  #Enable the amoeba gem for deep copy/clone (dup with associations)
  amoeba do
    enable

    customize(lambda { |original_wbs_project_elt, new_wbs_project_elt|
      new_wbs_project_elt.name = "Copy_#{ original_wbs_project_elt.copy_number.to_i+1} of #{original_wbs_project_elt.name }"
      new_wbs_project_elt.copy_number = 0
      original_wbs_project_elt.copy_number +=1
    })

    propagate
  end
end
