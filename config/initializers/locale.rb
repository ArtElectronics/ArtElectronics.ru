# Be sure to restart your server when you modify this file.

# Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
# Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.

# >>> MOVED TO APPLICATION.RB
# Rails.application.config.time_zone = 'Moscow'
# Rails.application.config.active_record.default_timezone = :local
# >>> MOVED TO APPLICATION.RB

# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
# Rails.application.config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
Rails.application.config.i18n.available_locales = [:en, :ru]
Rails.application.config.i18n.default_locale    = :ru
