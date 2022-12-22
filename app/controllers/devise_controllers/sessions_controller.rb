class SessionsController < Devise::SessionsController
  # skip_before_filter :verify_authenticity_token, only: [:create]
  layout 'bootstrap_default', except: %w[ new ]

  def create
    respond_to do |format|
      format.html { super }
      format.json do
        self.resource = warden.authenticate(auth_options)
        sign_in(resource_name, resource) if resource
        render status: ( current_user ? 200 : 422 )
      end
    end
  end
end
