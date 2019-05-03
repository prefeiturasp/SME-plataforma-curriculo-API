module Api
  class MethodologiesController < ApiController
    before_action :set_methodology, only: :show

    def show
      render :show
    end

    def index
      @challenges = Methodology.all

      render :index
    end

    private

      def set_methodology
        @methodology = Methodology.friendly.find params[:slug]
      end
  end
end
