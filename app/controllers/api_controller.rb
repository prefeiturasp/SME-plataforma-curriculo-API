class ApiController < ActionController::API
  helper ApplicationHelper
  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :render_no_content
  rescue_from ActionController::ParameterMissing, with: :render_unprocessable_entity
  # rescue_from MissingRating, with: :render_unprocessable_entity

  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :skip_set_cookies_header
  helper_method :current_teacher

  def current_teacher
    @current_teacher ||= current_user&.teacher
  end

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

  def render_unprocessable_entity(exception = nil)
    @response = response
    @request_path = request.path
    @message = exception

    render '/api/errors/errors', status: :unprocessable_entity
  end

  def render_unauthorized_resource
    render json: { error: 'Acesso negado' }, status: :unauthorized
  end

  def skip_set_cookies_header
    request.session_options[:skip] = true
  end
end
