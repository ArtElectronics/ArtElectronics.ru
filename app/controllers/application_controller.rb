class ApplicationController < ActionController::Base
  include RedirectBack
  include TheRoleAddons
  include TheRole::Controller
  include TheComments::ViewToken

  prepend_view_path "app/views/#{ AppConfig.theme }"

  before_filter :staging_auth
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def staging_auth
    unless Rails.env.development?
      authenticate_or_request_with_http_basic do |username, password|
        username == 'test' && password == 'test'
      end
    end
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def app_role_access_denied
    redirect_to new_user_session_path, alert: t('users.have_not_role')
  end

  alias_method :user_require,       :authenticate_user!
  alias_method :role_access_denied, :app_role_access_denied

  before_action :define_user
  after_action  :save_audit

  # override devise redirect path if successfull login
  def after_sign_in_path_for(resource)
    cabinet_path
  end

  private

  def define_user
    @root   = User.root
    @user   = current_user
    user_id = params[:user_id]

    if user_id
      @user = if TheFriendlyId.int? user_id
        User.find(user_id)
      else
        User.where(login: user_id).first
      end
    end
  end

  def save_audit
    (@audit || Audit.new.init(self)).save unless controller_name == 'audits'
  end

  def not_authenticated
    redirect_to new_user_session_path, alert: t('users.not_authenticated')
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :login
  end
end