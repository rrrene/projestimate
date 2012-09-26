class TranslationsController < ApplicationController

  #Listing translations pages
  def index
    set_page_title "Translations"
    I18n.backend.send(:init_translations)
    if params[:locale].nil?
      @translations = I18n.backend.send(:translations)[session[:current_locale].to_sym]
    else
      @translations = I18n.backend.send(:translations)[params[:locale].to_sym]
    end
    @available_locales = I18n.backend.send(:available_locales)
  end

  #Create a new entry
  def create
    params[:translations].each do |elem|
      I18n.backend.store_translations(:fr, { elem[0] => elem[1].first })
    end
    Translate::Storage.new(:fr).write_to_file

    redirect_to translations_url, :notice => "Added translation"
  end

  #Load translations from config/locale/*.yml files
  def load_translations
    @translations = I18n.backend.send(:translations)[params[:locale].to_sym]
  end

end
