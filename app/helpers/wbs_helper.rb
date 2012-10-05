module WbsHelper
  #Generate an powerful Work Breakdown Structure
    def generate_wbs(component, project, tree, gap)
      #Root is always display
      if component.is_root?
        tree << "<ul >
           #{wbs_root_links(component, project)}"
        end

      if component.has_children?
        gap = gap + 2
        tree << "<ul class='sortable' style='margin-left:#{gap}px; border-left: 1px solid black; padding-left: 8px;''>"
        component.children.sort_by(&:position).each do |c|
          if c.work_element_type.alias == "folder"
            tree << wbs_folder_links(c, project)
          elsif c.work_element_type.alias == "component"
            tree << wbs_navigation_links(c, 'wbs_element')
          elsif c.work_element_type.alias == "link"
            tree << wbs_navigation_links(c, 'wbs_link_blue')
          else
            tree << wbs_navigation_links(c, c.work_element_type.alias)
          end
          generate_wbs(c, project, tree, gap)
        end
        tree << "</ul>"
      else
        #Nothing
      end

      return tree
    end

    def wbs_navigation_links(c, image)
      "<li class='#{ c.id == session[:component_id] ? 'selected' : '' }'  >
        <div class='block_label'>
          <div class='#{c.work_element_type.alias}' onClick='toggle_folder(this);' ></div>
          #{ link_to(c.name, { :controller => 'components', :action => 'selected_component', :id => c.id}, :remote => true, :class => "libelle") }
        </div>
        <div class='block_link'>
          #{ link_to "", edit_component_path(c, :project_id => @project.id), :remote => true, :class => 'bl edit ' if can? :edit_a_component, Component}
          #{ link_to "", c, confirm: 'Are you sure?', method: :delete, :class => 'bl delete' if can? :delete_a_component, Component }
          #{ link_to "", { :controller => 'components', :action => 'up', :component_id => c.id, :wbs_id => c.wbs_id, :project_id => @project.id}, :remote => true, :class => 'bl up ' if can? :move_a_component, Component }
          #{ link_to "", { :controller => 'components', :action => 'down' ,:component_id => c.id, :wbs_id => c.wbs_id, :project_id => @project.id}, :remote => true, :class => 'bl down ' if can? :move_a_component, Component }
        </div>
      </li>"
    end


    def wbs_folder_links(c, project)
      "<li class='#{ c.id == session[:component_id] ? 'selected' : '' }' >
        <div class='block_label'>
          <div class='#{c.work_element_type.alias}' onClick='toggle_folder(this);' ></div>
          #{ link_to(c.name, { :controller => 'components', :action => 'selected_component', :id => c.id}, :remote => true, :class => "libelle") }
        </div>
        <div class='block_link'>
          #{ link_to("", { :controller => 'components', :action => 'new', :wbs_id => project.wbs.id, :comp_parent_id => c.id, :type_component => "folder" }, :remote => true, :class => 'bl new_folder ') if can? :add_a_component, Component}
          #{ link_to "", { :controller => 'components', :action => 'new', :wbs_id => project.wbs.id, :comp_parent_id => c.id, :type_component => "undefined" },:remote => true, :class => 'bl new_undefined ' if can? :add_a_component, Component }
          #{ link_to "", { :controller => 'components', :action => 'new', :wbs_id => project.wbs.id, :comp_parent_id => c.id, :type_component => "link" }, :remote => true, :class => 'bl new_link ' if can? :add_a_component, Component}
          #{ link_to "", edit_component_path(c, :project_id => @project.id), :remote => true, :class => 'bl edit ' if can? :edit_a_component, Component }
          #{ link_to "", c, confirm: 'Are you sure?', method: :delete, :class => 'bl delete ' if can? :delete_a_component, Component }
          #{ link_to "", { :controller => 'components', :action => 'up', :component_id => c.id, :wbs_id => c.wbs_id, :project_id => @project.id}, :remote => true, :class => 'bl up ' if can? :move_a_component, Component }
          #{ link_to "", { :controller => 'components', :action => 'down' ,:component_id => c.id, :wbs_id => c.wbs_id, :project_id => @project.id}, :remote => true, :class => 'bl down ' if can? :move_a_component, Component }
        </div>
      </li>"
    end

    def wbs_root_links(component, project)
      "<li>
        <div class='block_label'>
          <div class='#{component.work_element_type.alias}' onClick='toggle_folder(this);' ></div>
          #{ link_to(component.name, { :controller => 'components', :action => 'selected_component', :id => component.id}, :remote => true, :class => "libelle ") }
        </div>
        <div class='block_link'>
          #{ link_to("", { :controller => 'components', :action => 'new', :wbs_id => project.wbs.id, :comp_parent_id => component.id, :type_component => "folder" }, :remote => true, :class => 'bl new_folder') if can? :add_a_component, Component }
          #{ link_to "", { :controller => 'components', :action => 'new', :wbs_id => project.wbs.id, :comp_parent_id => component.id, :type_component => "" }, :remote => true, :class => 'bl new_undefined ' if can? :add_a_component, Component }
          #{ link_to "", { :controller => 'components', :action => 'new', :wbs_id => project.wbs.id, :comp_parent_id => component.id, :type_component => "link" }, :remote => true, :class => 'bl new_link '  if can? :add_a_component, Component }
          #{ link_to "", edit_component_path(component, :project_id => @project.id), :remote => true, :class => 'bl edit', :data_toggle => "modal" if can? :edit_a_component, Component }
        </div>
      </li>"
    end
end
