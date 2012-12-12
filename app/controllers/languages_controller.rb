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

class LanguagesController < ApplicationController
  # GET /languages
  # GET /languages.json
  def index
    authorize! :edit_languages, Language
    set_page_title "Languages"
    @languages = Language.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @languages }
    end
  end

  # GET /languages/1
  # GET /languages/1.json
  def show
    authorize! :edit_languages, Language
    @language = Language.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @language }
    end
  end

  # GET /languages/new
  # GET /languages/new.json
  def new
    authorize! :edit_languages, Language
    set_page_title "Add a language"
    ##@language = Language.new
    current_user.language.build

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @language }
    end
  end

  # GET /languages/1/edit
  def edit
    authorize! :edit_languages, Language
    set_page_title "Edit language"
    @language = Language.find(params[:id])
  end

  # POST /languages
  # POST /languages.json
  def create
    authorize! :edit_languages, Language
    @language = Language.new(params[:language])
    @language.record_status_id = RecordStatus.first.id
    if @language.save
      redirect_to redirect(@language), notice: 'Language was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /languages/1
  # PUT /languages/1.json
  def update
    authorize! :edit_languages, Language
    @language = Language.find(params[:id])

    if @language.update_attributes(params[:language])
      redirect_to redirect(@language), notice: 'Language was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /languages/1
  # DELETE /languages/1.json
  # Destroy method on Master table is not going to delete  definitively the record
  #It is only going to change ths record status : logical deletion
  def destroy
    authorize! :edit_languages, Language
    @language = Language.find(params[:id])
    #logical deletion
    @language.rec


    respond_to do |format|
      format.html { redirect_to languages_url }
    end
  end
end
