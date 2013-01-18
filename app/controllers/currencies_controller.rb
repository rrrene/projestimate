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

class CurrenciesController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

  def index
    authorize! :manage_currency, Currency
    @currencies = Currency.all
  end

  def show
    authorize! :manage_currency, Currency
    @currency = Currency.find(params[:id])
  end

  # GET /currencies/new
  # GET /currencies/new.json
  def new
    authorize! :manage_currency, Currency
    @currency = Currency.new
  end

  # GET /currencies/1/edit
  def edit
    authorize! :manage_currency, Currency
    @currency = Currency.find(params[:id])

    unless @currency.child.nil?
      if @currency.child.is_proposed_or_custom?
        flash[:notice] = "This currency can not be edited, previous changes have not yet been validated."
        redirect_to currencies_path
      end
    end
  end

  # POST /currencies
  # POST /currencies.json
  def create
    authorize! :manage_currency, Currency
    @currency = Currency.new(params[:currency])
    @currency.save
    redirect_to redirect(currencies_url)
  end

  # PUT /currencies/1
  # PUT /currencies/1.json
  def update
    authorize! :manage_currency, Currency
    @currency = nil
    current_currency = Currency.find(params[:id])
    if current_currency.is_defined?
      @currency = current_currency.amoeba_dup
      @currency.owner_id = current_user.id
    else
      @currency = current_currency
    end

    if @currency.update_attributes(params[:currency])
      redirect_to redirect(currencies_url), notice: 'Currency was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /currencies/1
  # DELETE /currencies/1.json
  def destroy
    authorize! :manage_currency, Currency
    @currency = Currency.find(params[:id])
    if @currency.is_defined? || @currency.is_custom?
      #logical deletion: delete don't have to suppress records anymore on defined record
      @currency.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
    else
      @currency.destroy
    end

    flash[:notice] = "Currency was successfully deleted."
    redirect_to currencies_url
  end
end
