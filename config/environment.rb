# Loads Cartographer Version (Javascript Google Maps)
CARTOGRAPHER_GMAP_VERSION = 3

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Creamery2012::Application.initialize!

# Date of birth format
Time::DATE_FORMATS[:dob] = "%d %b %Y"

