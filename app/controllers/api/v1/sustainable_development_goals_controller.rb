module Api
  module V1
    class SustainableDevelopmentGoalsController < ApiController
      before_action :set_sustainable_development_goal, only: %i[show update destroy]

      # GET /sustainable_development_goals
      def index
        @sustainable_development_goals = SustainableDevelopmentGoal.all

        render json: @sustainable_development_goals
      end

      # GET /sustainable_development_goals/1
      def show
        render json: @sustainable_development_goal
      end

      # POST /sustainable_development_goals
      def create
        @sustainable_development_goal = SustainableDevelopmentGoal.new(sustainable_development_goal_params)
        @sustainable_development_goal.icon.attach(sustainable_development_goal_params[:icon])

        if @sustainable_development_goal.save
          render json: @sustainable_development_goal, status: :created
        else
          render json: @sustainable_development_goal.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /sustainable_development_goals/1
      def update
        if sustainable_development_goal_params[:icon].present?
          @sustainable_development_goal.icon.attach(sustainable_development_goal_params[:icon])
        end
        if @sustainable_development_goal.update(sustainable_development_goal_params)
          render json: @sustainable_development_goal
        else
          render json: @sustainable_development_goal.errors, status: :unprocessable_entity
        end
      end

      # DELETE /sustainable_development_goals/1
      def destroy
        @sustainable_development_goal.icon.purge
        @sustainable_development_goal.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_sustainable_development_goal
        @sustainable_development_goal = SustainableDevelopmentGoal.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def sustainable_development_goal_params
        params.require(:sustainable_development_goal).permit(:sequence, :name, :description, :goals, :icon, :color)
      end
    end
  end
end
