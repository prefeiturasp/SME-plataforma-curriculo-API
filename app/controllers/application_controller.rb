class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_active_admin_user!
    authenticate_user!
  end

  def access_denied(exception)
    redirect_to '/', alert: exception.message
  end

  protected

  def after_sign_in_path_for(resource)
    current_user.admin? ? admin_root_path : '/'
  end
end
