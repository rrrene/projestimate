# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ProjestimateMaquette::Application.initialize!
#config.autoload_paths << File.join(config.root, "lib")

#Encoding.default_external = Encoding::UTF_8
#Encoding.default_internal = Encoding::UTF_8

COMMIT_VERSION = `git rev-list -n1 --abbrev-commit HEAD` unless defined? COMMIT_VERSION

#NEEDED_TO_UPDATE =`git pull --dry-run | grep -q -v 'Already up-to-date`  unless defined?  NEEDED_TO_UPDATE
#NEEDED_TO_UPDATE =%x(git pull --dry-run | grep -q -v 'Already up-to-date`)  unless defined?  NEEDED_TO_UPDATE