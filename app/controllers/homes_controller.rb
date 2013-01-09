class HomesController < ApplicationController
  def about
  end

  def update_install
    Home::update_master_data!
    $latest_update = Time.now
    flash[:notice] = "Projestimate data have been updated successfully."
    redirect_to "/about"
  end
end
