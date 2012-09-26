class ResultsController < ApplicationController
  #I dont know why I did that
  def create
    @staff = Result.new(params[:staff])
    @staff.save
  end
end
