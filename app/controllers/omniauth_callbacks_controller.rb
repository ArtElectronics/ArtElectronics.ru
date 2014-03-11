class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    auth
  end

  def facebook
    auth
  end

  def vkontakte
    auth
  end

  def failure
    # https://github.com/plataformatec/devise/blob/master/app/controllers/devise/omniauth_callbacks_controller.rb
    # do something on failure    
  end

  private

  def auth
    @omniauth = request.env['omniauth.auth']
    provider  = @omniauth['provider']
    uid       = @omniauth['uid']

    # return render js: "window.alert('hi');", layout: false
    return render :close_popup_and_redirect_to_cabinet, layout: false

    # if credential = Credential.find_by_provider_and_uid(provider, uid)
    #   sign_out current_user if current_user
    #   sign_in credential.user

    #   return render :close_popup_and_redirect_to_cabinet, layout: false
    # else
    #   render :insert_oauth_params_to_registration_form, layout: false
    # end
  end
end
