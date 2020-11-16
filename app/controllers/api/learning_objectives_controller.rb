module Api
  class LearningObjectivesController < ApiController
    def index
      @learning_objectives = LearningObjective.all
      if (params[:year_ids].present? && params[:curricular_component_ids].present?)
        @learning_objectives = LearningObjective.where(
          year_id: params[:year_ids],
          curricular_component_id: params[:curricular_component_ids]
        )
      end

      render json: @learning_objectives
    end

    private

    def learning_objective_params
      params.require(:learning_objective).permit(:title, :description, :year_ids, :curricular_component_ids, :code)
    end
  end
end
