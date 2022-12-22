class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json
  layout 'bootstrap_default'

  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?

    if resource_saved
      resource.reload

      SystemMessage.create_user_registration(resource)

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)

        if request.format.json?
          return render 'devise/registrations/created', layout: false, status: 200
        else
          respond_with resource, location: after_sign_up_path_for(resource)
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!

        if request.format.json?
          return render 'devise/registrations/account_should_be_activate', layout: false, status: 200
        else
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      end
    else
      if request.format.json?
        return render 'devise/registrations/validation_errors', layout: false, status: 422
      else
        clean_up_passwords resource
        respond_with resource
      end
    end
  end
end
