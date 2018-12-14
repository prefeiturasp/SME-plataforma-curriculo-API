class ApiController < ActionController::API
  helper ApplicationHelper
  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :render_no_content
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :skip_set_cookies_header

  protected

  def render_not_found
    @response = response
    @request_path = request.path
    @message = 'Request not found'
    render '/api/errors/errors', status: :not_found
  end

  def render_no_content(exception = nil)
    @response = response
    @request_path = request.path
    @message = exception

    render '/api/errors/errors', status: :no_content
  end

  def render_unauthorized_resource
    render json: { error: 'Acesso negado' }, status: :unauthorized
  end

  def skip_set_cookies_header
    request.session_options[:skip] = true
  end
end
