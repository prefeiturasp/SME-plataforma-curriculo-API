module Api
  module V1
    class OmniauthCallbacksController < Devise::OmniauthCallbacksController

      # skip_before_action :verify_authenticity_token, :only => [:consume] 

      def facebook
        # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.from_omniauth(request.env["omniauth.auth"])
    
        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
          set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
        else
          session["devise.facebook_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    
      def failure
        redirect_to root_path
      end

      def saml
        @user = User.from_omniauth(request.env["omniauth.auth"])

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
          set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
        else
          session["devise.facebook_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end

    end
  end
end