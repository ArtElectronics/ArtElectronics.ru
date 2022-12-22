class ApplicationController < ActionController::Base
  include RedirectBack
  include TheRole::Controller
  include TheComments::ViewToken

  prepend_view_path "app/views/bootstrap_default"
  prepend_view_path "app/views/#{ AppConfig.theme }"

  before_filter :staging_auth
  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_action :define_user
  after_action  :save_audit

  include TheRoleAddons

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_action ->{
    # https://apps.facebook.com
    if request.referer.to_s.match(/metrika\.yandex/mix)
      response.headers.except! 'X-Frame-Options'
    end

    if request.referer.to_s.match(/surfingbird/mix)
      response.headers.except! 'X-Frame-Options'
    end
  }

  def staging_auth
    # unless Rails.env.development?
    #   authenticate_or_request_with_http_basic do |username, password|
    #     username == 'test' && password == 'test'
    #   end
    # end
  end

  private

  def define_user
    @root   = User.root
    @user   = current_user
    user_id = params[:user_id]

    if user_id
      @user = if TheFriendlyId::Base.int? user_id
        User.find(user_id)
      else
        User.where(login: user_id).first
      end
    end
  end

  def save_audit
    begin
      if Audit.table_exists?
        (@audit || Audit.new.init(self)).save unless ['audits', 'omniauth_callbacks'].include? controller_name
      end
    rescue; end
  end

  def not_authenticated
    redirect_to new_user_session_path, alert: t('users.not_authenticated')
  end

  protected

  # Devise
  def after_sign_in_path_for(resource)
    cabinet_path
  end

  def after_sign_up_path_for(resource)
    cabinet_path
  end

  def after_inactive_sign_up_path_for(resource)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:oauth_data]
  end
  # ~ Devise

  def page_404
    # flash: { error: "Страница не найдена" }
    # redirect_to page_404_path, flash: { error: "Страница не найдена" }
    # flash[:error] = "Страница не найдена"

    render(template: 'welcome/page_404', status: 404)
  end
end
