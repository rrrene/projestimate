class HomesController < ApplicationController
  def update_install
    begin
      expire_fragment('about_page')

      if is_master_instance?
        flash[:error] = "You can't update yourself, as you already are on Master Instance"
        redirect_to "/about" and return
      else
        external_last_schemas_version = ExternalMasterDatabase::ExternalSchemaMigration.all.last
        version = nil
        #To get all version : ActiveRecord::Migrator.get_all_versions
        local_last_schema_version = ActiveRecord::Migrator.current_version  #current local migration version

        #if local_last_schema_version.to_i == external_last_schemas_version.version.to_i
        if local_last_schema_version.to_i >= external_last_schemas_version.version.to_i
          puts "Same schema version"

          #Test if local data are up to date
          latest_repo_update = Home::latest_repo_update
          if params[:latest_local_update].nil? || latest_repo_update.nil? || (params[:latest_local_update].to_datetime < latest_repo_update.to_datetime)
            Home::update_master_data!
            $latest_update = Time.now #Rails.cache.write("$latest_update", Time.now)
            flash[:notice] = "Projestimate data have been updated successfully."
          else
            puts "Your repository is up to date"
            flash[:notice] =  "You already have the latest MasterData."
          end

        else
          flash[:error] = "Your local DB schema differ to the MasterData one, please check for modifications or run 'rake db:migrate' command "
        end
      end

      redirect_to about_url

    rescue Errno::ECONNREFUSED
      flash[:error] = "!!! WARNING - Error: Default data was not loaded, please investigate. Maybe run bundle exec rake sunspot:solr:start RAILS_ENV=your_environnement"
      redirect_to about_url and return
    rescue Exception
      flash[:error] = "!!! WARNING - Exception: Default data was not loaded, please investigate... Maybe run db:create and db:migrate tasks."
      redirect_to about_url
    end
  end
end
