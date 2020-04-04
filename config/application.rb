require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NewApp01
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    
    config.generators.test_framework      = :rspec
    config.generators.system_tests        = false
    config.generators.stylesheets         = false
    config.generators.javascripts         = false
    config.generators.helper              = false
    config.generators.helper_specs        = false
    config.generators.view_specs          = false
 
  end
end

