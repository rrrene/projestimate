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

class CreateEjEstimationValues < ActiveRecord::Migration
  def change
    create_table :ej_estimation_values do |t|
      t.integer :project_id
      t.integer :pbs_project_element_id
      t.integer :wbs_activity_element_id
      t.float :minimum
      t.float :most_likely
      t.float :maximum
      t.float :probable

      t.timestamps
    end
  end
end
