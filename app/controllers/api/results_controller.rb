module Api
  class ResultsController < ApiController
    before_action :set_challenge, only: [:index, :create]
    before_action :set_result, only: [:show]

    def index
      @results = paginate @challenge.results

      render :index
    end

    def show
      render :show
    end

    def create
      #
    end

    private

      def set_result
        unless params[:challenge_slug].blank?
          challenge = Challenge.find params[:challenge_slug]
          @result = challenge.results.where(id: params[:id]).first
        else
          @result = Result.find params[:id]
        end
      end

      def set_challenge
        @challenge = Challenge.friendly.find params[:challenge_slug]
      end
  end
end
