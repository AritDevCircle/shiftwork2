require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Shiftwork2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.exceptions_app = self.routes
    
    # Set official app timezone
    config.time_zone = "UTC"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
      class_attr_index = html_tag.index 'class="'
      if class_attr_index
        html_tag.insert class_attr_index+7, 'error '
      else
        html_tag.insert html_tag.index('>'), ' class="error"'
      end
    end
  end
end