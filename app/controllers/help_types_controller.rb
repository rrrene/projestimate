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

class HelpTypesController < ApplicationController
  # GET /help_types
  # GET /help_types.json
  def index
    @help_types = HelpType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @help_types }
    end
  end

  # GET /help_types/1
  # GET /help_types/1.json
  def show
    @help_type = HelpType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @help_type }
    end
  end

  # GET /help_types/new
  # GET /help_types/new.json
  def new
    @help_type = HelpType.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @help_type }
    end
  end

  # GET /help_types/1/edit
  def edit
    @help_type = HelpType.find(params[:id])
  end

  # POST /help_types
  # POST /help_types.json
  def create
    @help_type = HelpType.new(params[:help_type])

    respond_to do |format|
      if @help_type.save
        format.html { redirect_to @help_type, notice: 'Help type was successfully created.' }
        format.json { render json: @help_type, status: :created, location: @help_type }
      else
        format.html { render action: "new" }
        format.json { render json: @help_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /help_types/1
  # PUT /help_types/1.json
  def update
    @help_type = HelpType.find(params[:id])

    respond_to do |format|
      if @help_type.update_attributes(params[:help_type])
        format.html { redirect_to @help_type, notice: 'Help type was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @help_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /help_types/1
  # DELETE /help_types/1.json
  def destroy
    @help_type = HelpType.find(params[:id])
    @help_type.destroy

    respond_to do |format|
      format.html { redirect_to help_types_url }
      format.json { head :ok }
    end
  end
end
