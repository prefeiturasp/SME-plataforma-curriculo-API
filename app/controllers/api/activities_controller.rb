module Api
  class ActivitiesController < ApiController
    before_action :set_activity, only: %i[show]

    def show
      render :show
    end

    private

    def activity_sequence_params
      params.permit(:slug)
    end

    def set_activity
      @activity = Activity.friendly.find(params[:activity_slug])
    end
  end
end
