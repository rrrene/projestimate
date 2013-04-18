class WbsProjectElement < ActiveRecord::Base

  has_ancestry :cache_depth => true

  belongs_to :pe_wbs_project
  belongs_to :wbs_activity_element
  belongs_to :wbs_activity
  belongs_to :wbs_activity_ratio  #Default Wbs-Activity-Ratio
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

  # Sort tree in an ordered List accordingly to the tree structure (for example to represent the children in a sorted out list in a select)
  def self.arrange_as_array(options={}, hash=nil)
    hash ||= arrange(options)

    arr = []
    hash.each do |node, children|
      arr << node
      arr += arrange_as_array(options, children) unless children.empty?
    end
    arr
  end

  # Test if element is from the Library and if it's a leaf element
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

  # Test if element can have another children
  def update_can_get_new_child
    if !self.parent.can_get_new_child.nil? && self.parent.can_get_new_child?
      self.can_get_new_child = false
      self.save
    end
  end

  def cannot_get_new_child_link?
    !self.can_get_new_child.nil? && !self.can_get_new_child?
  end

end
