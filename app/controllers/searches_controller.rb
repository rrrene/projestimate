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

class SearchesController < ApplicationController
  load_and_authorize_resource

  #Display search result
  def results
    if params[:search].class == Array
      classes = params[:search][:classes].map { |i| String::keep_clean_space(i).camelcase.constantize }
    else
      classes = [PeAttribute, ProjectArea, PlatformCategory, ProjectCategory, WorkElementType, PbsProjectElement, Project, Pemodule]
    end

    @results = Array.new
    classes.each do |class_name|
      @res = class_name.search do
        fulltext params[:search]
      end

      @results << @res.results
    end
    @results = @results.flatten
  end

end