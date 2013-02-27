module WbsActivityElementsHelper

  def generate_activity_element_tree(element, tree)
    #Root is always display
    tree ||= String.new
    unless element.nil?
      if element.is_root?
        tree << "<ul style='margin-left:1em;' id='tree'>
                   <li style='margin-left:-1em;'>
                    <div class='block_label'>
                        #{show_element_name(element)}
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
                        #{show_element_name(e)}
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


  def generate_wbs_project_elt_tree(element, tree, show_hidden=false)
    #Root is always display
    tree ||= String.new
    unless element.nil?
      #unless element.exclude
        if element.is_root?
          tree << "<ul style='margin-left:1em;' id='tree'>
                     <li style='margin-left:-1em;'>
                      <div class='block_label'>
                          #{show_element_name(element)}
                      </div>
                      <div class='block_link'>
                        #{ link_activity_element(element) }
                      </div>
                    </li>"
        end

        if element.has_children?
          tree << "<ul class='sortable'>"
          element.children.each do |e|
            if show_hidden
              tree << "<ul>
                         <li style='margin-left:#{element.depth}em;' >
                          <div class='block_label'>
                            #{show_element_name(e)}
                          </div>
                          <div class='block_link'>
                            #{ link_activity_element(e) }
                          </div>
                        </li>"

              generate_wbs_project_elt_tree(e, tree)
            else
              unless e.exclude
                tree << "<ul>
                           <li style='margin-left:#{element.depth}em;' >
                            <div class='block_label'>
                              #{show_element_name(e)}
                            </div>
                            <div class='block_link'>
                              #{ link_activity_element(e) }
                            </div>
                          </li>"

                generate_wbs_project_elt_tree(e, tree)
              end
            end
          end
          tree << "</ul>"
        #end
      end
    end
    tree
  end


  def show_element_name(element)
    if element.attributes.has_key? "record_status_id"
      if element.is_root?
        "<span class='#{ element.record_status.to_s }'>Root element - #{element.name} </span>"
      else
        "<span class='#{ element.record_status.to_s }'> #{element.name} </span>"
      end

    else
      if element.is_root?
        "<span class=''>#{element.pe_wbs_project.name}</span>"
      else
        "<span class=''> #{element.name} </span>"
      end
    end
  end


  def link_activity_element(element)
    res = String.new
    if element.attributes.has_key? "record_status_id"
      res << link_to( '', new_wbs_activity_element_path(:selected_parent_id => element.id, :activity_id => element.wbs_activity_id), :class => "icon-plus icon-large")
      res << link_to( '', edit_wbs_activity_element_path(element, :activity_id => element.wbs_activity_id), :class => "icon-edit icon-large", :title => "Edit", :confirm => ("We don't provide any workflow to modify this table, if you continue you will be editing the 'defined' record itself. Please confirm you accept to continue" if element.is_defined?) )
      res << link_to( '', element, confirm: 'Are you sure?', method: :delete, :class => "icon-trash icon-large", :title => "supprimer")

    else
      res << link_to( '', new_wbs_project_element_path(:selected_parent_id => element.id, :project_id => @project.id), :class => "icon-plus icon-large", :title => "New")
      res << link_to( '', edit_wbs_project_element_path(element, :project_id => @project.id), :class => 'bl edit', :title => "Edit")
      res << link_to_unless(element.is_root?,  '', wbs_project_element_path(element, :project_id => @project.id), confirm: 'Are you sure?', method: :delete, :project_id => @project.id, :class => "icon-trash icon-large", :title => "Delete")
    end
    res
  end

end
