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

class StaffsController < ApplicationController
  ## GET /staffs
  ## GET /staffs.json
  #def index
  #  @staffs = Staff.all
  #
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.json { render json: @staffs }
  #  end
  #end
  #
  ## GET /staffs/1
  ## GET /staffs/1.json
  #def show
  #  @staff = Staff.find(params[:id])
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @staff }
  #  end
  #end
  #
  ## GET /staffs/new
  ## GET /staffs/new.json
  #def new
  #  @staff = Staff.new
  #
  #  respond_to do |format|
  #    format.html # _new.html.erb
  #    format.json { render json: @staff }
  #  end
  #end
  #
  ## GET /staffs/1/edit
  #def edit
  #  @staff = Staff.find(params[:id])
  #end
  #
  ## POST /staffs
  ## POST /staffs.json
  #def create
  #  @staff = Staff.new(params[:staff])
  #
  #  respond_to do |format|
  #    if @staff.save
  #      format.html { redirect_to @staff, notice: 'Staff was successfully created.' }
  #      format.json { render json: @staff, status: :created, location: @staff }
  #    else
  #      format.html { render action: "new" }
  #      format.json { render json: @staff.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end
  #
  ## PUT /staffs/1
  ## PUT /staffs/1.json
  #def update
  #  @staff = Staff.find(params[:id])
  #
  #  respond_to do |format|
  #    if @staff.update_attributes(params[:staff])
  #      format.html { redirect_to @staff, notice: 'Staff was successfully updated.' }
  #      format.json { head :ok }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @staff.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end
  #
  ## DELETE /staffs/1
  ## DELETE /staffs/1.json
  #def destroy
  #  @staff = Staff.find(params[:id])
  #  @staff.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to staffs_url }
  #    format.json { head :ok }
  #  end
  #end
end
