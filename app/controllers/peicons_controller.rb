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
class PeiconsController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

  def index
    set_page_title "Icons libraries"
    @icons = Peicon.all
  end

  def new
    set_page_title "Icons libraries"
    @icon = Peicon.new
  end

  def edit
    set_page_title "Icons libraries"
    @icon = Peicon.find(params[:id])
  end

  def create
    set_page_title "Icons libraries"
    @icon = Peicon.new(params[:peicon])
    if @icon.save
      redirect_to redirect(peicons_path)
    else
      flash[:error] = "Icons #{ @icon.errors.values.flatten.join(" and ")}"
      render :new
    end
  end

  def update
    set_page_title "Icons libraries"
    current_icon = Peicon.find(params[:id])
    @icon = current_icon.dup

    if @icon.update_attributes(params[:peicon])
      redirect_to redirect(peicons_path)
    else
      flash[:error] = "Icons #{ @icon.errors.values.flatten.join(" and ")}"
      render :edit
    end
  end

  def destroy
    @peicon = Peicon.find(params[:id])
    @peicon.icon = nil
    @peicon.save
    @peicon.destroy
    redirect_to peicons_path
  end

  def choose_icon
    @peicon = Peicon.find(params[:id])
  end
end
