module Api
  class ResultsController < ApiController
    before_action :set_challenge, only: [:show, :create]

    def create
      #
    end

    def index
      @results = paginate @challenge.results

      render :index
    end

    private

      def set_challenge
        @challenge = Challenge.friendly.find params[:challenge_slug]
      end
  end
end
