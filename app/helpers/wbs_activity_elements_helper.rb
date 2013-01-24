module WbsActivityElementsHelper

  def generate_activity_element_tree(element, gap)
    #Root is always display
    tree = String.new
    unless element.nil?
      if element.is_root?
        tree << "<ul>
                   <li>
                    <div class='block_label'>
                      <div>
                        <span class='#{ element.record_status.to_s == 'Proposed' ? 'label label-important' : '' }' >Root element - #{element.name} </span>
                      </div>
                    </div>
                    <div class='block_link'>
                      #{ link_activity_element(element) }
                    </div>
                  </li>"
      end

      if element.has_children?
        gap = gap + 2
        tree << "<ul class='sortable' style='margin-left:#{gap}px; border-left: 1px solid black; padding-left: 8px;''>"
        element.children.each do |e|
          tree << "<ul>
                     <li>
                      <div class='block_label'>
                        <div>
                        <span class='#{ (e.record_status.to_s == "Proposed") ? 'label label-important' : '' }' > #{e.name} </span>
                        </div>
                      </div>
                      <div class='block_link'>
                        #{ link_activity_element(e) }
                      </div>
                    </li>"

          generate_activity_element_tree(e, gap)
        end
        tree << "</ul>"
      end
    end
    tree
  end

  def link_activity_element(element)
    res = String.new
    res << link_to( '', new_wbs_activity_element_path, :class => "icn_duplicate")
    res << link_to( '', edit_wbs_activity_element_path(element), :class => "icn_edit", :title => "Edit")
    res << link_to( '', element, confirm: 'Are you sure?', method: :delete, :class => "icn_trash", :title => "Delete")

    if is_master_instance? && !(element.record_status.to_s == 'Local')
      if element.record_status.to_s == 'Retired'
        res << link_to('', 'wbs_activity_elements/#{wbs_activity_element.id}/restore_change', confirm: 'Do you confirm restoring this record as defined ?', :title => 'restore changes', :class => 'icn_jump_back')
      else
        unless element.record_status.to_s == 'Defined'
          res << link_to('', 'wbs_activity_elements/#{wbs_activity_element.id}/validate_change', confirm: 'Do you confirm changes validation on this record?', :title => 'validate changes', :class => 'icn_check_in')
        end
      end
    end

    res
  end

end
