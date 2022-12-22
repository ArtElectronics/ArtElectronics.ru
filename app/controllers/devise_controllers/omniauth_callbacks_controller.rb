class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  %w[ vkontakte facebook twitter google_oauth2 ].each do |network_name|
    define_method network_name do
      auth
    end
  end

  def failure
    render text: :oauth_failure
    # https://github.com/plataformatec/devise/blob/master/app/controllers/devise/omniauth_callbacks_controller.rb
    # do something on failure
  end

  private

  def auth
    @omniauth = request.env['omniauth.auth']
    provider, uid = @omniauth['provider'], @omniauth['uid']

    if current_user
      uid          = @omniauth['uid']
      provider     = @omniauth['provider']
      _credentials = @omniauth.try(:[], 'credentials')

      current_user.create_credential_with_oauth(uid, provider, _credentials)
      return render :linked_with_social_network, layout: false
    end

    # TODO: we need to update credential in someday
    # credential.update(token, expired ... etc)
    result_action = if credential = Credential.find_by_provider_and_uid(provider, uid)
      sign_out current_user if current_user
      sign_in  credential.user
      :close_popup_and_redirect_to_cabinet
    else
      :insert_oauth_params_to_registration_form
    end

    return render result_action, layout: false
  end
end
