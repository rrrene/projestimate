class HomesController < ApplicationController
  def update_install
    begin
      Home::update_master_data!
      $latest_update = Time.now
      flash[:notice] = "Projestimate data have been updated successfully."
      redirect_to "/about" and return

    rescue Errno::ECONNREFUSED
      flash[:error] = "!!! WARNING - Error: Default data was not loaded, please investigate. <br /> Maybe run bundle exec rake sunspot:solr:start RAILS_ENV=your_environnement"
      redirect_to "/about" and return
    rescue Exception
      flash[:error] = "!!! WARNING - Exception: Default data was not loaded, please investigate... <br /> Maybe run db:create and db:migrate tasks."
      redirect_to "/about"
    end
  end
end
