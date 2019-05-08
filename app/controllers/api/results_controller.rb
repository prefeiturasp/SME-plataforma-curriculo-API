module Api
  class ResultsController < ApiController
    before_action :set_challenge, only: [:index, :create]
    before_action :set_result,    only: [:show]

    def index
      @results = paginate @challenge.results

      render :index
    end

    def show
      render :show
    end

    def create
      @result = Result.new result_params

      if @result.save
        render json: { location: api_challenge_result_path(
            challenge_slug: @result.challenge.slug,
            id:             @result.id
          ) }, status: :created
      else
        render json: @result.errors, status: :unprocessable_entity
      end
    end

    private

      def result_params
        nparams = params.require(:result).permit :description,
                                                 :class_name,
                                                 :teacher_id,
                                                 :challenge_id,
                                                 archives: [],
                                                 links_attributes: [:link]

        nparams[:challenge_id] = @challenge.id if nparams[:challenge_id].blank?
        nparams
      end

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
