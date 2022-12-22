require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Assets should be precompiled for production (so we don't need the gems loaded then)
Bundler.require(*Rails.groups(assets: %w(development test)))

module TheApp
  class Application < Rails::Application
    require_relative 'configs'
    config.autoload_paths += %W(#{config.root}/app/controllers/devise_controllers)
  end
end
