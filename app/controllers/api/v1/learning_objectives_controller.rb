module Api
  module V1
    class LearningObjectivesController < ApplicationController
      before_action :set_learning_objective, only: %i[show update destroy]

      # GET /learning_objectives
      def index
        @learning_objectives = LearningObjective.all

        render json: @learning_objectives
      end

      # GET /learning_objectives/1
      def show
        render json: @learning_objective
      end

      # POST /learning_objectives
      def create
        @learning_objective = LearningObjective.new(learning_objective_params)

        if @learning_objective.save
          render json: @learning_objective, status: :created
        else
          render json: @learning_objective.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /learning_objectives/1
      def update
        if @learning_objective.update(learning_objective_params)
          render json: @learning_objective
        else
          render json: @learning_objective.errors, status: :unprocessable_entity
        end
      end

      # DELETE /learning_objectives/1
      def destroy
        @learning_objective.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_learning_objective
        @learning_objective = LearningObjective.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def learning_objective_params
        params.require(:learning_objective).permit(
          :year_id,
          :code,
          :description,
          :curricular_component_id,
          :segment_id,
          :stage_id,
          sustainable_development_goal_ids: []
        )
      end
    end
  end
end
