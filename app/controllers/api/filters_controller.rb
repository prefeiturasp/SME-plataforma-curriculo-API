module Api
  class FiltersController < ApiController
    before_action :fetch_axes, only: %i[index]
    before_action :fetch_learning_objectives, only: %i[index]

    def index
      @years = LearningObjective.years

      @curricular_components = CurricularComponent.all
      @sustainable_development_goals = SustainableDevelopmentGoal.all
      @knowledge_matrices = KnowledgeMatrix.all

      @curricular_components.present? ? render(:index) : render(json: {}, status: :no_content)
    end

    private

    def set_activity_sequence_params
      params.permit(
        :years,
        :curricular_component_slugs
      )
    end

    def fetch_axes
      @axes = Axis.all_or_with_curricular_component(params[:curricular_component_slugs])
    end

    def fetch_learning_objectives
      return if params[:years].blank? && params[:curricular_component_slugs].blank?
      @learning_objectives = LearningObjective.all_or_with_year(params[:years])
                                              .all_or_with_curricular_component(params[:curricular_component_slugs])
    end
  end
end
