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

module ModuleProjectsHelper

  def probable_value_save(results, mpa)
    attribute_alias = mpa.attribute.alias.to_sym
    if mpa.attribute.attribute_type == "numeric"
      min = results[:low][attribute_alias].to_f
      ml = results[:most_likely][attribute_alias].to_f
      high = results[:high][attribute_alias].to_f
      res = (min+4*ml+high)/6
    else
      "-"
    end
  end

  def probable_value(results, mpa, with_activities=false)
    attribute_alias = mpa.attribute.alias.to_sym
    if with_activities
      if mpa.attribute.attribute_type == "numeric"
        min = results[:low][attribute_alias].to_f
        ml = results[:most_likely][attribute_alias].to_f
        high = results[:high][attribute_alias].to_f
        res = (min+4*ml+high)/6
        res
      else
        "-"
      end
    else #only PBS are evaluated
      if with_activities
        if mpa.attribute.attribute_type == "numeric"
          min = results[:low][attribute_alias].to_f
          ml = results[:most_likely][attribute_alias].to_f
          high = results[:high][attribute_alias].to_f
          res = (min+4*ml+high)/6
          res
        else
          "-"
        end
      end
    end
  end


end
