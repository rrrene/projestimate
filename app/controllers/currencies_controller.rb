class CurrenciesController < ApplicationController

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
  end

  # POST /currencies
  # POST /currencies.json
  def create
    authorize! :manage_currency, Currency
    @currency = Currency.new(params[:currency])
    redirect_to currencies_url
  end

  # PUT /currencies/1
  # PUT /currencies/1.json
  def update
    authorize! :manage_currency, Currency
    @currency = Currency.find(params[:id])
    redirect_to currencies_url
  end

  # DELETE /currencies/1
  # DELETE /currencies/1.json
  def destroy
    authorize! :manage_currency, Currency
    @currency = Currency.find(params[:id])
    @currency.destroy
    redirect_to currencies_url
  end
end
