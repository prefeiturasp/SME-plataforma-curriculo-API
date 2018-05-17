class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_active_admin_user!
    authenticate_user!
    return if current_user.superadmin?
    flash[:alert] = 'Unauthorized Access!'
    sign_out current_user
    redirect_to new_user_session_path
  end
end
