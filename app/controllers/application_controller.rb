class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: :verify_api

  def authenticate_active_admin_user!
    authenticate_user!
  end

  def access_denied(exception)
    redirect_to '/', alert: exception.message
  end

  protected

  def verify_api
    permitted_routes = %w[api]
    if params[:controller]
      (params[:controller].split('/') & permitted_routes).any?
    else
      false
    end
  end
end
