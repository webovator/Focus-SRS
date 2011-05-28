class TranslationsController < ApplicationController
before_filter :authenticate_user!

  def index
    @translations = TRANSLATION_STORE
  end

  def create
    I18n.backend.store_translations(params[:locale], {params[:key] => params[:value]}, :escape => false)
    redirect_to translations_url, :notice => "Added translation"
  end
  
  def show
  end
end