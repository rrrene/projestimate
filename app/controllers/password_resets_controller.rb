#encoding: utf-8
#TODO:rename this controller to LoginController or to something most eloquent/verbose/meaningful
class PasswordResetsController < ApplicationController
  layout "login"

  #Display "forgotten password" page
  def new
  end

  #Reset the password depending of the status of the user
  def create
    user = User.first(:conditions => ['user_name = ? or email = ?', params[:user_name], params[:user_name] ])
    if user
      if user.type_auth == "app"
        if user.active?
          user.send_password_reset if user
          redirect_to root_url, :notice => "Password reset instructions have been sent."
        else
          user.send_password_reset if user
          redirect_to root_url, :notice => "Your account is not active"
        end
      else
        redirect_to root_url, :notice => "Your account is associated with the corporate directory. Please contact your system administrator."
      end
    else
      redirect_to root_url, :notice => "Bad user name"
    end
  end

  #Edit the new password
  #checks token validity
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  #Update the new password
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      UserMailer.new_password(@user).deliver
      redirect_to new_password_reset_path, :alert => "Reset processus expired."
    elsif @user.update_attributes(params[:user])
      UserMailer.new_password(@user).deliver
      redirect_to root_url, :notice => "Your password has been reset successfully. A confirmation email have been sent."
    else
      render :edit
    end
  end

  #def forgotten_password
  #  @user = User.find_by_email(params[:email])
  #  UserMailer.forgotten_password(@user).deliver
  #end

end

