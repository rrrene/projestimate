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

module PeWbsProjectsHelper
  #Generate an powerful Work Breakdown Structure

  ##========================================== FOR WBS PRODUCT ======================================================##

  def generate_wbs_product(pbs_project_element, project, tree, gap, is_project_show_view = false)

    all_pbs_project_element = pbs_project_element.children.sort_by(&:position)

    #Root is always display
    if !pbs_project_element.nil? && pbs_project_element.is_root?
      tree << "<ul>
         #{wbs_root_links(pbs_project_element, project, is_project_show_view)}"
    end

    if pbs_project_element.has_children?
      gap = gap + 2
      tree << "<ul class='sortable' style='margin-left:#{gap}px; border-left: 1px solid black; padding-left: 8px;''>"
      all_pbs_project_element.each do |c|
        if c.work_element_type.alias == "folder"
          tree << wbs_folder_links(c, project, is_project_show_view)
        else
          tree << wbs_navigation_links(c, is_project_show_view)
        end
        generate_wbs_product(c, project, tree, gap)
      end
      tree << "</ul>"
    else
      #Nothing
    end

    return tree
  end

  def wbs_navigation_links(c, is_project_show_view)
    "<li class=''>
        <div class='block_label #{ c == current_component ? "selected_pbs" : '' }'>
          #{  image_tag c.work_element_type.peicon.nil? ? '' : c.work_element_type.peicon.icon.url(:small)}
          #{  content_tag('span', '', :class => "#{ c.is_completed ? 'icon-star' : 'icon-star-empty' } ") }
          #{  content_tag('span', '', :class => "#{ c.is_validated ? 'icon-circle' : 'icon-circle-blank' } ") }
          #{  link_to(c.link? ? (c.project_link.nil? ? '!! undefined link' : Project.find(c.project_link)) : c.name, {:controller => 'pbs_project_elements', :action => 'selected_pbs_project_element', :pbs_id => c.id, :project_id => @project.id, :is_project_show_view => is_project_show_view}, :remote => true, :confirm => ('You are going to modify a validated PBS, confirm to continue or abort to cancel ?' if c.is_validated)) }
        </div>
        <div class='block_link'>
          #{ link_to "", edit_pbs_project_element_path(c, :project_id => @project.id), :remote => true, :class => 'button_attribute_tooltip icon-edit icon-large icon-border', :title => I18n.t('edit') unless is_project_show_view }
          #{ link_to "", c, confirm: I18n.t('are_you_sur'), method: :delete, :remote => true, :class => 'button_attribute_tooltip icon-trash icon-large icon-border', :title => I18n.t('delete') unless is_project_show_view }
          #{ link_to "", {:controller => 'pbs_project_elements', :action => 'up', :pbs_project_element_id => c.id, :pe_wbs_project_id => c.pe_wbs_project_id, :project_id => @project.id}, :remote => true, :class => 'button_attribute_tooltip icon-arrow-up icon-large icon-border', :title => I18n.t('up') unless is_project_show_view }
          #{ link_to "", {:controller => 'pbs_project_elements', :action => 'down', :pbs_project_element_id => c.id, :pe_wbs_project_id => c.pe_wbs_project_id, :project_id => @project.id}, :remote => true, :class => 'button_attribute_tooltip icon-arrow-down icon-large icon-border', :title => I18n.t('down')  unless is_project_show_view }
        </div>
      </li>"
  end

  def wbs_folder_links(c, project, is_project_show_view)
    "<li class='' >
        <div class='block_label #{ c == current_component ? 'selected_pbs' : '' }'>
          <div onClick='toggle_folder(this);' >
            #{ image_tag c.work_element_type.peicon.nil? ? '' : c.work_element_type.peicon.icon.url(:small)}
            #{  content_tag('span', '', :class => "#{ c.is_completed ? 'icon-star' : 'icon-star-empty' } ") }
            #{  content_tag('span', '', :class => "#{ c.is_validated ? 'icon-circle' : 'icon-circle-blank' } ") }
            #{ link_to(c.name, {:controller => 'pbs_project_elements', :action => 'selected_pbs_project_element', :pbs_id => c.id, :is_project_show_view => is_project_show_view}, :remote => true, :class => "") }
          </div>
        </div>
        <div class='block_link'>
          #{ link_to "", edit_pbs_project_element_path(c, :project_id => @project.id), :remote => true, :class => 'button_attribute_tooltip icon-edit icon-large icon-border', :title => I18n.t('edit') unless is_project_show_view }
          #{ link_to "", new_pbs_project_element_path(:project_id => @project.id), :remote => true, :class => 'button_attribute_tooltip icon-folder-open icon-large icon-border', :title => I18n.t('add_folder') unless is_project_show_view }
          #{ link_to "", new_pbs_project_element_path(:project_id => @project.id), :remote => true, :class => 'button_attribute_tooltip icon-plus icon-large icon-border', :title => I18n.t('add_component') unless is_project_show_view }
          #{ link_to "", new_pbs_project_element_path(:project_id => @project.id), :remote => true, :class => 'button_attribute_tooltip icon-link icon-large icon-border', :title => I18n.t('add_link') unless is_project_show_view }
          #{ link_to "", c, confirm: I18n.t('are_you_sur'), method: :delete, :remote => true, :class => 'button_attribute_tooltip icon-trash icon-large', :title => I18n.t('delete')}
          #{ link_to "", {:controller => 'pbs_project_elements', :action => 'up', :pbs_project_element_id => c.id, :pe_wbs_project_id => c.pe_wbs_project_id, :project_id => @project.id}, :remote => true, :class => 'button_attribute_tooltip icon-arrow-up icon-large icon-border', :title => I18n.t('up') unless is_project_show_view }
          #{ link_to "", {:controller => 'pbs_project_elements', :action => 'down', :pbs_project_element_id => c.id, :pe_wbs_project_id => c.pe_wbs_project_id, :project_id => @project.id}, :remote => true, :class => 'button_attribute_tooltip icon-arrow-down icon-large icon-border', :title => I18n.t('down') unless is_project_show_view }
        </div>
    </li>"
  end

  def wbs_root_links(pbs_project_element, project, is_project_show_view)
    "<li class=''>
        <div class='block_label #{ pbs_project_element == current_component ? 'selected_pbs' : '' }'>
          <div onClick='toggle_folder(this);' >
            #{ image_tag pbs_project_element.work_element_type.peicon.nil? ? '' : pbs_project_element.work_element_type.peicon.icon.url(:small) }
            #{  content_tag('span', '', :class => "#{ pbs_project_element.is_completed ? 'icon-star' : 'icon-star-empty' } ") }
            #{  content_tag('span', '', :class => "#{ pbs_project_element.is_validated ? 'icon-circle' : 'icon-circle-blank' } ") }
            #{ link_to(pbs_project_element.name, {:controller => 'pbs_project_elements', :action => 'selected_pbs_project_element', :pbs_id => pbs_project_element.id, :project_id => @project.id, :is_project_show_view => is_project_show_view}, :remote => true, :class => " ") }
          </div>
        </div>
        <div class='block_link'>
          #{ link_to "", edit_pbs_project_element_path(pbs_project_element, :project_id => @project.id), :remote => true, :class => 'button_attribute_tooltip icon-edit icon-large icon-border', :title => I18n.t('edit') unless is_project_show_view }
          #{ link_to("", new_pbs_project_element_path(:project_id => @project.id), :remote => true, :class => 'button_attribute_tooltip icon-folder-open icon-large icon-border', :title => I18n.t('add_folder')) unless is_project_show_view }
          #{ link_to "", new_pbs_project_element_path(:project_id => @project.id), :remote => true, :class => 'button_attribute_tooltip icon-plus icon-large icon-border', :title => I18n.t('add_component') unless is_project_show_view }
          #{ link_to "", new_pbs_project_element_path(:project_id => @project.id), :remote => true, :class => 'button_attribute_tooltip icon-link icon-large icon-border', :title => I18n.t('add_link') unless is_project_show_view }
        </div>
      </li>"
  end
end



