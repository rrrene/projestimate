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

end