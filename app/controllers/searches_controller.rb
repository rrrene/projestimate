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

class SearchesController < ApplicationController

  #Display search result
  def results

    if params[:search].class == Array
      classes = params[:search][:classes].map{ |i| String::keep_clean_space(i).camelcase.constantize }
    else
      classes = [Attribute, ProjectArea, PlatformCategory, ProjectCategory, WorkElementType, Component, Project, Pemodule]
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

  def user_search
    unless params[:states] == ""
      @users = User.where(:user_status => params[:states]).search(params[:user_searches]).page(params[:page]).per_page(5)
    else
      @users = User.search(params[:user_searches]).page(params[:page]).per_page(5)
    end
  end

  def project_search
    @projects = Project.search(params[:project_searches]).page(params[:page]).per_page(5)
  end

end