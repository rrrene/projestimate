class HomesController < ApplicationController
  def update_install
    begin
      if is_master_instance?
        flash[:error] = "You can't update yourself, as you already are on Master Instance"
        redirect_to "/about" and return
      else
        external_last_schemas_version = ExternalMasterDatabase::ExternalSchemaMigration.all.last
        version = nil
        #To get all version : ActiveRecord::Migrator.get_all_versions
        local_last_schema_version = ActiveRecord::Migrator.current_version  #current local migration version

        if local_last_schema_version.to_i == external_last_schemas_version.version.to_i
          puts "Same schema version"

          #Get my current branch name
          current_branch_name = `git name-rev --name-only HEAD`
          puts "CURRENT_BRANCH_NAME = #{current_branch_name}"
          differences = `git diff $current_branch_name...origin/master`   #differences = `git diff dev...origin/dev`
          puts "DIFF = #{differences}"
          need_to_pull = "test"

          #if need_to_pull.nil? || need_to_pull.blank?
          if differences.blank?
            puts "Your repository is up to date"
            flash[:notice] =  "you already have the latest MasterData"
          else
            Home::update_master_data!
            $latest_update = Time.now
            flash[:notice] = "Projestimate data have been updated successfully."
          end

        else
          flash[:error] = "Your local DB schema differ to the MasterData one, please check for modifications or run 'rake db:migrate' command "
        end
      end

      redirect_to("/about") and return

    rescue Errno::ECONNREFUSED
      flash[:error] = "!!! WARNING - Error: Default data was not loaded, please investigate. Maybe run bundle exec rake sunspot:solr:start RAILS_ENV=your_environnement"
      redirect_to "/about" and return
    rescue Exception
      flash[:error] = "!!! WARNING - Exception: Default data was not loaded, please investigate... Maybe run db:create and db:migrate tasks."
      redirect_to "/about"
    end
  end
end
