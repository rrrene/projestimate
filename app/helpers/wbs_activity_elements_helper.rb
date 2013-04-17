#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012-2013 Spirula (http://www.spirula.fr)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
########################################################################

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
          if show_hidden == "true"
            tree << "<ul>
                       <li style='margin-left:#{element.depth}em;' >
                        <div class='block_label'>
                          #{show_element_name(e)}
                        </div>
                        <div class='block_link'>
                          #{ link_activity_element(e) }
                        </div>
                      </li>"

            generate_wbs_project_elt_tree(e, tree, show_hidden)
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

                generate_wbs_project_elt_tree(e, tree, show_hidden)
              end
          end
        end
        tree << "</ul>"
      end
    end
    tree
  end


  def show_element_name(element)
    if element.attributes.has_key? "record_status_id"
      if element.is_root?
        "<span class='#{ element.record_status.to_s }'> Root element - #{element.name} </span>"
      else
        "<span class='#{ element.record_status.to_s }'> #{element.name} </span>"
      end

    else
      if element.is_root?
        #"<span class=''>#{element.pe_wbs_project.name} WBS-Activity</span>"
        "<span class=''>#{@project.title} WBS-Activity : Activity breakdown Structure </span>"
      else
        "<span class=''> #{element.name} </span>"
      end
    end
  end


  def link_activity_element(element)
    res = String.new
    if element.attributes.has_key? "record_status_id"
      res << link_to( '', new_wbs_activity_element_path(:selected_parent_id => element.id, :activity_id => element.wbs_activity_id), :class => "bl icon-plus icon-large")
      res << link_to( '', edit_wbs_activity_element_path(element, :activity_id => element.wbs_activity_id), :class => "bl icon-edit icon-large", :title => "Edit", :confirm => (I18n.t(:text_master_force_edit) if element.is_defined?) )
      res << link_to( '', element, confirm: 'Are you sure?', method: :delete, :class => "bl icon-trash icon-large", :title => "Delete")

      unless enable_update_in_local?
        res = link_to('', wbs_activity_element_path(element, :activity_id => element.wbs_activity_id), method: :get, :class => "bl icon-eye-open icon-large", :title => "Show", :remote => true)
      end

    else
      res << link_to_unless(element.is_from_library_and_is_leaf?, '', new_wbs_project_element_path(:selected_parent_id => element.id, :project_id => @project.id), :class => "bl icon-plus icon-large", :title => "New")
      res << link_to_unless(element.is_root?, '', edit_wbs_project_element_path(element, :project_id => @project.id), :class => 'bl icon-edit icon-large', :title => "Edit")
      res << link_to_unless(element.is_root?,  '', wbs_project_element_path(element, :project_id => @project.id), confirm: 'Are you sure?', method: :delete, :project_id => @project.id, :class => "bl icon-trash icon-large", :title => "Delete") unless  !element.destroy_leaf
      res << link_to_if(element.is_added_wbs_root,  '', "wbs_project_elements/#{element.id}/change_wbs_project_ratio", :wbs_project_element_id => element.id,  :project_id => @project.id, :class => "bl icon-share icon-large", :title => "Change Ratio", :remote => true)
    end
    res
  end

end
