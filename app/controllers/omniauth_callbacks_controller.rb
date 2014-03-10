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

  private

  def auth
    @omniauth = request.env['omniauth.auth']
    @user = User.new(oauth_params: @omniauth)
    @user.save

    # sign_out current_user if current_user
    # @omniauth = request.env['omniauth.auth']
#     user = find_user_for_oauth_ 555

#     if user.persisted?
#       sign_in_and_redirect user
#     else
# # binding.pry      
#       session[:omniauth] = @omniauth.to_json  
#       redirect_to new_user_registration_path
#     end

  end

  def find_user_for_oauth_ auth
    begin 
      User.find auth
    rescue 
      User.new 
    end;
  end
end