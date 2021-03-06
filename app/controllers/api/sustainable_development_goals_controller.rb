module Api
  class SustainableDevelopmentGoalsController < ApiController
    before_action :set_sustainable_development_goal, only: %i[show]

    def index
      @sustainable_development_goals = SustainableDevelopmentGoal.all.with_attached_icon.order(:sequence)

      render :index
    end

    def show
      render :show
    end

    private

    def sustainable_development_goal_params
      params.permit(:id)
    end

    def set_sustainable_development_goal
      @sustainable_development_goal = SustainableDevelopmentGoal.find(params[:id])
    end
  end
end
