class PasswordsController < Devise::PasswordsController
  layout 'bootstrap_default'
  layout 'application', only: %w[ new edit ]
  skip_before_filter :require_no_authentication, only: [:edit, :update]
end
