module Api
  class ChallengesController < ApiController
    before_action :set_challenge, only: :show

    def show
      render :show
    end

    def index
      @challenges = Challenge.published
      @challenges = paginate params[:state] == 'finalizados' ?
        @challenges.finished : @challenges.ongoing

      render :index
    end

    private

      def set_challenge
        @challenge = Challenge.friendly.find params[:slug]
      end
  end
end
