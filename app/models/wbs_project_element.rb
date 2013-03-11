class WbsProjectElement < ActiveRecord::Base

  #attr_accessible :additional_description, :ancestry, :description, :exclude, :name, :author_id, :wbs_activity_element_id, :wbs_activity_id

  has_ancestry

  belongs_to :pe_wbs_project
  belongs_to :wbs_activity_element
  belongs_to :wbs_activity
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"

  scope :elements_root, where(:is_root => true)

  validates :name, :presence => true, :uniqueness => {:scope => :ancestry, :case_sensitive => false}

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

  def is_from_library_and_is_leaf?
    unless self.is_root
      if self.wbs_activity.nil? && self.wbs_activity_element.nil? && self.parent.can_get_new_child.nil?
        false
      else
        if self.has_children?
          true
        else
          if self.parent.can_get_new_child?
            true
          else
            false
          end
        end
      end
    end
  end

end
