module WbsProjectElementsHelper
#  #Generate an powerful Work Breakdown Structure
  def generate_wbs_project_element(wbs_project_element, project, tree, gap)
    #Root is always display
    if wbs_project_element.is_root?
      tree << "<ul >
           #{wbs_project_element_root_links(wbs_project_element, project)}"
    end

    if wbs_project_element.has_children?
      gap = gap + 2
      tree << "<ul class='sortable' style='margin-left:#{gap}px; border-left: 1px solid black; padding-left: 8px;''>"
      wbs_project_element.children.sort_by(&:position).each do |c|

        tree << wbs_activity_navigation_links(c)

        generate_wbs_project_element(c, project, tree, gap)
      end
      tree << "</ul>"
    else
      #Nothing
    end

    return tree
  end


  def wbs_activity_navigation_links(c)
    "<li class='#{ c.id == session[:wbs_project_element_id] ? 'selected' : '' }'  >
        <div class='block_label'>
          <div>
            #{ link_to(c.name, { :controller => 'wbs_project_elements', :action => 'selected_wbs_project_element', :id => c.id}, :remote => true, :class => "libelle") }
          </div>
        </div>
        <div class='block_link'>
          #{ link_to "", edit_wbs_project_element_path(c, :project_id => @project.id), :remote => true, :class => 'bl edit' if can? :edit_a_wbs_project_element, WbsProjectElement}
          #{ link_to "", c, confirm: 'Are you sure?', method: :delete, :remote => true, :class => 'bl delete' if can? :delete_a_wbs_project_element, WbsProjectElement }
        </div>
      </li>"
  end


  def wbs_project_element_links(c, project)
    "<li class='#{ c.id == session[:wbs_project_element_id] ? 'selected' : '' }' >
        <div class='block_label'>
          <div onClick='toggle_folder(this);' >
            #{ link_to(c.name, { :controller => 'wbs_project_elements', :action => 'selected_wbs_project_element', :id => c.id}, :remote => true, :class => "libelle") }
          </div>
        </div>
        <div class='block_link'>
          #{ link_to("", { :controller => 'wbs_project_elements', :action => 'new', :pe_wbs_project_id => project.pe_wbs_project.id, :comp_parent_id => c.id, :type_component => "folder" }, :remote => true, :class => 'bl new_folder ') if can? :add_a_wbs_project_element, WbsProjectElement}
          #{ link_to "", { :controller => 'wbs_project_elements', :action => 'new', :pe_wbs_project_id => project.pe_wbs_project.id, :comp_parent_id => c.id, :type_component => "undefined" },:remote => true, :class => 'bl new_undefined ' if can? :add_a_wbs_project_element, WbsProjectElement }
          #{ link_to "", { :controller => 'wbs_project_elements', :action => 'new', :pe_wbs_project_id => project.pe_wbs_project.id, :comp_parent_id => c.id, :type_component => "link" }, :remote => true, :class => 'bl new_link ' if can? :add_a_wbs_project_element, WbsProjectElement}
          #{ link_to "", edit_wbs_project_element_path(c, :project_id => @project.id), :remote => true, :class => 'bl edit' if can? :edit_a_wbs_project_element, WbsProjectElement }
          #{ link_to "", c, confirm: 'Are you sure?', method: :delete, :remote => true, :class => 'bl delete' if can? :delete_a_wbs_project_element, WbsProjectElement }
        </div>
      </li>"
  end


  def wbs_project_element_root_links(wbs_project_element, project)
    "<li>
        <div class='block_label'>
          <div onClick='toggle_folder(this);' >
            #{ link_to(project.title, { :controller => 'wbs_project_elements', :action => 'selected_wbs_project_element', :id => wbs_project_element.id}, :remote => true, :class => "libelle ") }
          </div>
        </div>
        <div class='block_link'>
          #{ link_to "", { :controller => 'wbs_project_elements', :action => 'new', :pe_wbs_project_id => project.pe_wbs_project.id, :parent_id => wbs_project_element.id }, :remote => true, :class => 'bl new_link '  if can? :add_a_wbs_project_element, WbsProjectElement }
          #{ link_to "", edit_wbs_project_element_path(wbs_project_element, :project_id => @project.id), :remote => true, :class => 'bl edit' if can? :edit_a_wbs_project_element, PbsProjectElement }
        </div>
      </li>"
  end

end
