require 'uglifier'
require "#{ Rails.root }/config/initializers/application_config"

TheApp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_assets = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor  = Uglifier.new(output: { ascii_only: true, quote_keys: true })
  config.assets.js_compressor  = :uglifier
  config.assets.css_compressor = :sass
  # config.assets.raise_runtime_errors = true

  # Whether to fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Set to :debug to see everything in the log.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.

  config.assets.paths << "#{ Rails.root }/public/javascripts"
  theme = [:application, AppConfig.theme].join('_')
  config.assets.precompile += %W[
    bootstrap_default.css
    bootstrap_default.js

    #{ theme }.css
    #{ theme }.js

    bootstrap_default/addons/*
    vendors/*
  ]

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found).
  config.i18n.fallbacks = true

  # :ignore_exceptions => ExceptionNotifier.ignored_exceptions,
  # :ignore_crawlers => %w{Googlebot bingbot AhrefsBot YandexBot},
  # :ignore_if => ->(env, exception) { exception.message =~ /^Sometext/ }
  TheApp::Application.config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[AE production error]",
    :sender_address => %{"Error robot" <robot@artelectronics.ru>},
    :exception_recipients => %w{zykin-ilya@ya.ru}
  }

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL).
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Disable automatic flushing of the log to improve performance.
  # config.autoflush_log = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new
end
