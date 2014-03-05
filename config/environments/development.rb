TheApp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  
  config.assets.paths << "#{ Rails.root }/public/javascripts"


  # Mail

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  # devise
  config.action_mailer.default_url_options = { host: "localhost:3000" }
  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    :port => 587,
    :domain => "gmail.com",
    :user_name => "densomart.sel1@gmail.com",
    :password => "densomart",
    :authentication => "plain",
    :enable_starttls_auto => true
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers.
  config.action_dispatch.best_standards_support = :builtin

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL).
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  config.assets.debug = true

  # Enable AssetsPipeline
  config.assets.enabled = true
end
