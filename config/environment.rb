# Load the rails application.
require File.expand_path('../application', __FILE__)

# RM deprication warns
I18n.config.enforce_available_locales = true

# Initialize the rails application.
TheApp::Application.initialize!
  #TODO delete it
  # fishing methods>=, before Devise integration has completed
  def require_login()
    true
  end

  def current_user
    User.first
  end
