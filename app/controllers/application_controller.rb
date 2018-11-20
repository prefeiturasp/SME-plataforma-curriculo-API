class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, if: :verify_api

  skip_before_action :verify_authenticity_token

  def authenticate_active_admin_user!
    authenticate_user!
  end

  def access_denied(exception)
    redirect_to '/', alert: exception.message
  end

  protected

  def verify_api
    params[:controller].split('/')[0] != 'devise_token_auth'
  end
end
