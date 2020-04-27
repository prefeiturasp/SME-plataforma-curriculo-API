module Api
  class SessionsController < Devise::SessionsController
    before_action :skip_set_cookies_header
    before_action :authenticate_in_sme, only: [:create]
    respond_to :json

    def create
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?

      render 'api/profiles/me'
    end

    private

    def authenticate_in_sme
      render_failed_login unless User.authenticate_in_sme(custom_login_params)
    end

    def custom_login_params
      custom = sign_in_params
      custom[:login] = sign_in_params[:login]
      custom[:senha] = sign_in_params[:password]
      custom.delete(:password)

      custom
    end

    def respond_with(resource, _opts = {})
      render json: resource
    end

    def respond_to_on_destroy
      head :no_content
    end

    def skip_set_cookies_header
      request.session_options[:skip] = true
    end

    def render_failed_login
      render json: { error: 'Login ou senha inválidos.' }, status: :unauthorized
    end
  end
end
