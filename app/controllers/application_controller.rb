class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, if: :verify_not_api

  def authenticate_active_admin_user!
    authenticate_user!
  end

  def access_denied(exception)
    redirect_to '/', alert: exception.message
  end

  protected

  def verify_not_api
    !params[:controller].split('/').include?('api')
  end
end
