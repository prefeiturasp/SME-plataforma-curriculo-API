module Api
  class SessionsController < Devise::SessionsController
    before_action :skip_set_cookies_header
    respond_to :json

    def create
      super
    end

    def destroy
      super
    end

    private

    def respond_with(resource, _opts = {})
      render json: resource
    end

    def respond_to_on_destroy
      head :no_content
    end

    def skip_set_cookies_header
      request.session_options[:skip] = true
    end
  end
end
