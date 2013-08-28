require 'spec_helper'

class ApplicationController < ActionController::Base


  def current_user
    begin
      (User.find(session[:current_user_id]) if session[:current_user_id]) || (User.find_by_email(cookies[:login]) if cookies[:login] || nil)
    rescue ActiveRecord::RecordNotFound
      reset_session
    end
  end
end

describe ApplicationController do

end