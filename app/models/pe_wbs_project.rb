#########################################################################
#
# ProjEstimate, Open Source project estimation web application
# Copyright (c) 2012 Spirula (http://www.spirula.fr)
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

#PE-WBS6Project has many pbs_project_element and belongs to project
class PeWbsProject < ActiveRecord::Base
  has_many :pbs_project_elements, :dependent => :destroy

  belongs_to :project

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :project_id, :presence => true

  #Enable the amoeba gem for deep copy/clone (dup with associations)
  amoeba do
    enable
    include_field :pbs_project_elements

    customize(lambda { |original_pe_wbs, new_pe_wbs|
      new_pe_wbs.name = "PE-WBS Copy_#{ new_pe_wbs.project.copy_number.to_i+1} of #{new_pe_wbs.project.title }"          #"Copy_#{ original_project.copy_number.to_i+1} of #{original_project.title}"
    })

    propagate
  end

end
