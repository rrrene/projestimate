#encoding: utf-8
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

class HelpsController < ApplicationController
  # GET /helps
  # GET /helps.json
  def index
    @helps = Help.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @helps }
    end
  end

  # GET /helps/1
  # GET /helps/1.json
  def show
    @help = Help.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @help }
    end
  end

  # GET /helps/new
  # GET /helps/new.json
  def new
    @help = Help.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @help }
    end
  end

  # GET /helps/1/edit
  def edit
    @help = Help.find(params[:id])
  end

  # POST /helps
  # POST /helps.json
  def create
    @help = Help.new(params[:help])

    respond_to do |format|
      if @help.save
        format.html { redirect_to @help, notice: 'Help was successfully created.' }
        format.json { render json: @help, status: :created, location: @help }
      else
        format.html { render action: "new" }
        format.json { render json: @help.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /helps/1
  # PUT /helps/1.json
  def update
    @help = Help.find(params[:id])

    respond_to do |format|
      if @help.update_attributes(params[:help])
        format.html { redirect_to @help, notice: 'Help was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @help.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /helps/1
  # DELETE /helps/1.json
  def destroy
    @help = Help.find(params[:id])
    @help.destroy

    respond_to do |format|
      format.html { redirect_to helps_url }
      format.json { head :ok }
    end
  end
end
