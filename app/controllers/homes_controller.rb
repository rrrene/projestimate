class HomesController < ApplicationController
  def update_install
    begin
      expire_fragment('about_page')

      if is_master_instance?
        flash[:error] = I18n.t (:cant_update_yourself)
        redirect_to "/about" and return
      else
        external_last_schemas_version = ExternalMasterDatabase::ExternalSchemaMigration.all.last
        version = nil
        #To get all version : ActiveRecord::Migrator.get_all_versions
        local_last_schema_version = ActiveRecord::Migrator.current_version  #current local migration version

        #if local_last_schema_version.to_i == external_last_schemas_version.version.to_i
        if local_last_schema_version.to_i >= external_last_schemas_version.version.to_i
          puts I18n.t (:same_schema_version)

          #Test if local data are up to date
          latest_repo_update = Home::latest_repo_update
          if params[:latest_local_update].nil? || latest_repo_update.nil? || (params[:latest_local_update].to_datetime < latest_repo_update.to_datetime)
            Home::update_master_data!
            $latest_update = Time.now #Rails.cache.write("$latest_update", Time.now)
            flash[:notice] = I18n.t (:projestimate_data_succesfull_update)
          else
            puts I18n.t (:reprository_up_to_date)
            flash[:notice] =  I18n.t (:already_have_latest_masterdata)
          end

        else
          flash[:error] = I18n.t (:db_schema_differ_to_masterdata)
        end
      end

      redirect_to about_url

    rescue Errno::ECONNREFUSED
      flash[:error] = I18n.t (:default_data_not_load_error)
      redirect_to about_url and return
    rescue Exception
      flash[:error] = I18n.t (:default_data_not_load_exception)
      redirect_to about_url
    end
  end
end
