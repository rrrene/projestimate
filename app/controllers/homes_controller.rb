class HomesController < ApplicationController
  def about
  end

  def update_install
    Home::update_master_data!
    $latest_update = Time.now
    redirect_to root_url
  end
end
