module Api
  class ChallengesController < ApiController
    before_action :set_challenge, only: :show

    def show
      render :show
    end

    private

      def set_challenge
        @challenge = Challenge.friendly.find params[:slug]
      end
  end
end
