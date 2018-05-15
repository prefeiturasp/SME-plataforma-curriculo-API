class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_active_admin_user!
    authenticate_user!
    return if current_user.superadmin?
    flash[:alert] = 'Unauthorized Access!'
    redirect_to '/'
  end
end
