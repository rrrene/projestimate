module WbsActivityElementsHelper

  def generate_activity_element_tree(element, tree)
    #Root is always display
    tree ||= String.new
    unless element.nil?
      if element.is_root?
        tree << "<ul style='margin-left:1em;' id='tree'>
                   <li style='margin-left:-1em;'>
                    <div class='block_label'>
                        <span class='#{ element.record_status.to_s }'>Root element - #{element.name} </span>
                    </div>
                    <div class='block_link'>
                      #{ link_activity_element(element) }
                    </div>
                  </li>"
      end

      if element.has_children?
        tree << "<ul class='sortable'>"
        element.children.each do |e|
          tree << "<ul>
                     <li style='margin-left:#{element.depth}em;' >
                      <div class='block_label'>
                        <span class='#{ e.record_status.to_s }'> #{e.name} </span>
                      </div>
                      <div class='block_link'>
                        #{ link_activity_element(e) }
                      </div>
                    </li>"

          generate_activity_element_tree(e, tree)
        end
        tree << "</ul>"
      end
    end
    tree
  end

  def link_activity_element(element)
    res = String.new
    res << link_to( '', new_wbs_activity_element_path(:selected_parent_id => element.id,:activity_id => element.wbs_activity), :class => "icn_duplicate")
    res << link_to( '', edit_wbs_activity_element_path(element, :activity_id => element.wbs_activity), :class => "icn_edit", :title => "Edit")
    res << link_to( '', element, confirm: 'Are you sure?', method: :delete, :class => "icn_trash", :title => "Delete")

    res

  end

end
