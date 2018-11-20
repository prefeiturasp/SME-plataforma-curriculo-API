module Api
  module V1
    class NovoOmniauthCallbacksController < Devise::OmniauthCallbacksController
    
      def failure
        redirect_to root_path
      end

      def saml
        @resource = User.from_omniauth(request.env["omniauth.auth"])

        if @resource.persisted?
          set_token_on_resource
          create_auth_params

          sign_in(:user, @resource, store: false, bypass: false)
      
          render_data_or_redirect('deliverCredentials', @auth_params.as_json, @resource.as_json)

          # sign_in_and_redirect @resource, event: :authentication #this will throw if @resource is not activated
          # set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
        else
          session["devise.facebook_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end


      protected

      def set_token_on_resource
        @client_id, @token, @expiry = @resource.create_token
      end

      def create_auth_params
        @auth_params = {
          auth_token:     @token,
          client_id: @client_id,
          uid:       @resource.uid,
          expiry:    @expiry,
          config:    @config
        }
        @auth_params.merge!(oauth_registration: true) if @oauth_registration
        @auth_params
      end

      def render_data_or_redirect(message, data, user_data = {})

        # We handle inAppBrowser and newWindow the same, but it is nice
        # to support values in case people need custom implementations for each case
        # (For example, nbrustein does not allow new users to be created if logging in with
        # an inAppBrowser)
        #
        # See app/views/devise_token_auth/omniauth_external_window.html.erb to understand
        # why we can handle these both the same.  The view is setup to handle both cases
        # at the same time.
        omniauth_window_type = ['newWindow']
        if ['inAppBrowser', 'newWindow'].include?(omniauth_window_type)
          render_data(message, user_data.merge(data))

        elsif auth_origin_url # default to same-window implementation, which forwards back to auth_origin_url

          # build and redirect to destination url
          redirect_to DeviseTokenAuth::Url.generate(auth_origin_url, data.merge(blank: true))
        else

          # there SHOULD always be an auth_origin_url, but if someone does something silly
          # like coming straight to this url or refreshing the page at the wrong time, there may not be one.
          # In that case, just render in plain text the error message if there is one or otherwise
          # a generic message.
          fallback_render data[:error] || 'An error occurred'
        end
      end

      def auth_origin_url
        omniauth_params['auth_origin_url'] || omniauth_params['origin']
      end



    end
  end
end
