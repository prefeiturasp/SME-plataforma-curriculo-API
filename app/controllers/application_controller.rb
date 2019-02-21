class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception, unless: :verify_api
  helper_method :current_teacher

  def authenticate_active_admin_user!
    authenticate_user!
  end

  def access_denied(exception)
    redirect_to '/', alert: exception.message
  end

  def current_teacher
    @current_teacher ||= current_user&.teacher
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

  def configure_permitted_parameters
    added_attrs = %i[username email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_in
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
