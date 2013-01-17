module PeWbsHelper

  def self.included(base)

    base.class_eval do

      helper_method :current_user_wbs_activities

      #Show all WBS-Activities of all current_user Organizations
      def current_user_wbs_activities
        begin
          user_wbs_activities_collection = []
          current_user_organizations = current_user.organizations.all
          current_user_organizations.each do |organization|
            user_wbs_activities_collection = user_wbs_activities_collection + organization.wbs_activities
          end
          user_wbs_activities_collection.uniq
        rescue
          user_wbs_activities_collection
        end
      end
    end
  end

end

