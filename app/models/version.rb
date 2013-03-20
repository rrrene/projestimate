class Version < ActiveRecord::Base
  attr_accessible :comment, :local_latest_update, :repository_latest_update
end
