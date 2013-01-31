class HomesController < ApplicationController
  def update_install
    if is_master_instance?
      flash[:error] = "You can't update yourself, as you already are on Master Instance"
      redirect_to "/about"
    else
      #begin

        #"git remote show origin"   "git config --get remote.origin.url"
        #git log -1 --format="%cd"      #To obtain date and time of the last commit in a current branch one
        #git log --name-status HEAD^..HEAD
        # git show --summary
        # git show --stat
       #git log -1 --stat

      external_last_schemas_version = ExternalMasterDatabase::ExternalSchemaMigration.all.last
        version = nil
        #To get all version : ActiveRecord::Migrator.get_all_versions
        local_last_schema_version = ActiveRecord::Migrator.current_version  #current local migration version

        if local_last_schema_version.to_i == external_last_schemas_version.version.to_i
          Home::update_master_data!
          $latest_update = Time.now
          flash[:notice] = "Projestimate data have been updated successfully."
          redirect_to "/about" and return
        else
          flash[:error] = "Your local DB schema differ to the MasterData one, please check for modifications or run 'rake db:migrate' command "
          redirect_to "/about" and return
        end

      #rescue Errno::ECONNREFUSED
      #  flash[:error] = "!!! WARNING - Error: Default data was not loaded, please investigate. Maybe run bundle exec rake sunspot:solr:start RAILS_ENV=your_environnement"
      #  redirect_to "/about" and return
      #rescue Exception
      #  flash[:error] = "!!! WARNING - Exception: Default data was not loaded, please investigate... Maybe run db:create and db:migrate tasks."
      #  redirect_to "/about"
      #end
    end
  end
end
