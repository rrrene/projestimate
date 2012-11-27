# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ProjestimateMaquette::Application.initialize!
#config.autoload_paths << File.join(config.root, "lib")

#Encoding.default_external = Encoding::UTF_8
#Encoding.default_internal = Encoding::UTF_8

APP_VERSION = `git describe --always` unless defined? APP_VERSION