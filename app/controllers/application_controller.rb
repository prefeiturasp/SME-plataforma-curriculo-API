class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :exception, if: :verify_api

  skip_before_action :verify_authenticity_token

  def verify_api
    params[:controller].split('/')[0] != 'devise_token_auth'
  end

  def authenticate_active_admin_user!
    authenticate_user!
  end

  def access_denied(exception)
    redirect_to '/', alert: exception.message
  end

  protected

  # def after_sign_in_path_for(resource = nil)
  #   current_user.admin? ? admin_root_path : '/'
  # end
end
