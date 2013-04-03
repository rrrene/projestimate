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

    if is_master_instance?
      unless @auth_method.child_reference.nil?
        if @auth_method.child_reference.is_proposed_or_custom?
          flash[:notice] = I18n.t (:auth_method_cant_be_edited)
          redirect_to auth_methods_path and return
        end
      end
    else
      if @auth_method.is_local_record?
        @auth_method.record_status = @local_status
      else
        flash[:error] = I18n.t (:master_record_cant_be_edited)
        redirect_to auth_methods_path
      end
    end
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
      @auth_method = current_auth_method.amoeba_dup
      @auth_method.owner_id = current_user.id
    else
      @auth_method = current_auth_method
    end

    unless is_master_instance?
      if @auth_method.is_local_record?
        @auth_method.custom_value = "Locally edited"
      end
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
    #If we are on local instance, Status is set to "Local"
    if is_master_instance?
      @auth_method.record_status = @proposed_status
    else
      @auth_method.record_status = @local_status
    end

    if @auth_method.save
      redirect_to redirect(auth_methods_path)
    else
      render(:new)
    end
  end

  def destroy
    @auth_method = AuthMethod.find(params[:id])
    if is_master_instance?
      if @auth_method.is_defined? || @auth_method.is_custom?
        #logical deletion  delete don't have to suppress records anymore on Defined record
        @auth_method.update_attributes(:record_status_id => @retired_status.id, :owner_id => current_user.id)
      else
        @auth_method.destroy
      end
    else
      if @auth_method.is_local_record? || @auth_method.is_retired?
        @auth_method.destroy
      else
        flash[:error] = I18n.t (:master_record_cant_be_deleted)
        redirect_to redirect(auth_methods_path)  and return
      end
    end

    respond_to do |format|
      format.html { redirect_to auth_methods_url, notice: "#{I18n.t (:auth_method_succesfull_deleted)}"}
    end
  end
end
