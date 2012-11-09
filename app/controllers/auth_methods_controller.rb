class AuthMethodsController < ApplicationController

  def index
    set_page_title "Authentications Method"
    @auth_methods = AuthMethod.all.reject{|i| i.name == "Application" }
  end

  def edit
    @auth_method = AuthMethod.find(params[:id])
    set_page_title "Edit #{@auth_method.name}"
  end

  def new
    set_page_title "New authentication method"
    @auth_method = AuthMethod.new
  end

  def update
    set_page_title "Authentications Method"
    @auth_method = AuthMethod.find(params[:id])
    if @auth_method.update_attributes(params[:auth_method])
      redirect_to redirect(auth_methods_path)
    else
      render(:edit)
    end
  end

  def create
    set_page_title "Authentications Method"
    @auth_method = AuthMethod.new(params[:auth_method])
    if @auth_method.save
      redirect_to redirect(auth_methods_path)
    else
      render(:new)
    end
  end

  def destroy

  end
end
