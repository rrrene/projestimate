class AuthMethodsController < ApplicationController
  include DataValidationHelper #Module for master data changes validation

  before_filter :get_record_statuses

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
    @auth_method = nil
    current_auth_method = AuthMethod.find(params[:id])
    if current_auth_method.is_defined?
      @auth_method = current_auth_method.dup
    else
      @auth_method = current_auth_method
    end

    if @auth_method.update_attributes(params[:auth_method])
      redirect_to redirect(auth_methods_path)
    else
      render action: "edit"
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
    @auth_method = AuthMethod.find(params[:id])
    if @auth_method.is_defined?
      #logical deletion  delete don't have to suppress records anymore on Defined record
      @auth_method.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
    else
      @auth_method.destroy
    end

    respond_to do |format|
      format.html { redirect_to auth_methods_url, notice: "Authentication method was successfully deleted." }
    end
  end
end
