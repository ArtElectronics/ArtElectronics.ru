class RegistrationsController < Devise::RegistrationsController
  def sign_up_params
    params = devise_parameter_sanitizer.sanitize(:sign_up)

    binding.pry

    params
  end
end