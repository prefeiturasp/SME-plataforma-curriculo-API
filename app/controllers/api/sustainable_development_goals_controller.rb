module Api
  class SustainableDevelopmentGoalsController < ApiController
    def index
      @sustainable_development_goals = SustainableDevelopmentGoal.all
      raise ActiveRecord::RecordNotFound unless @sustainable_development_goals.present?

      render :index
    end
  end
end
