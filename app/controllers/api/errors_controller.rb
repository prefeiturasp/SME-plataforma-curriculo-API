module Api
  class ErrorsController < ApiController
    def catch_404
      raise ActionController::RoutingError, params[:path]
    end
  end
end
