module TheRoleAddons
  extend ActiveSupport::Concern

  included do
    def access_denied
      render :text => 'access_denied: requires an role' and return
    end

    def app_role_access_denied
      current_user ? redirect_back(notice: t('users.have_not_role')) : redirect_to('/')
    end

    alias_method :role_access_denied, :access_denied
    alias_method :user_require,       :authenticate_user!
    alias_method :role_access_denied, :app_role_access_denied
  end
end
