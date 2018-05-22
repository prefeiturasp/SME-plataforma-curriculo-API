class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_active_admin_user!
    authenticate_user!
  end
end
