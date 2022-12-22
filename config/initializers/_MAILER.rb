config = Rails.application.config

config.action_mailer.preview_path = "#{ Rails.root }/app/mailers" if Rails.env.development?
config.action_mailer.default_url_options = { host: Settings.mailer.host }

if Settings.mailer.service == 'smtp'
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.smtp_settings = {
    address: Settings.mailer.smtp.default.address,
    domain:  Settings.mailer.smtp.default.domain,
    port:    Settings.mailer.smtp.default.port,

    user_name: Settings.mailer.smtp.default.user_name,
    password:  Settings.mailer.smtp.default.password,

    authentication: Settings.mailer.smtp.default.authentication,
    enable_starttls_auto: true
  }
elsif Settings.mailer.service == 'sandmail'
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.sendmail_settings = {
    location:  Settings.mailer.sandmail.location,
    arguments: Settings.mailer.sandmail.arguments
  }
else
  config.action_mailer.delivery_method = :test
  config.action_mailer.raise_delivery_errors = false
end
