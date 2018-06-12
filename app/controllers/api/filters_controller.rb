module Api
  class FiltersController < ApiController
    before_action :fetch_axes, only: %i[index]
    before_action :fetch_learning_objectives, only: %i[index]

    def index
      @years = LearningObjective.years

      @curricular_components = CurricularComponent.all
      @sustainable_development_goals = SustainableDevelopmentGoal.all
      @knowledge_matrices = KnowledgeMatrix.all
      @activity_types = ActivityType.all

      @curricular_components.present? ? render(:index) : render(json: {}, status: :no_content)
    end

    private

    def set_activity_sequence_params
      params.permit(
        :year,
        :curricular_component_slug
      )
    end

    def fetch_axes
      return if params[:year].blank? && params[:curricular_component_slug].blank?
      @axes = Axis.all_or_with_year(params[:year])
                  .all_or_with_curricular_component(params[:curricular_component_slug])
    end

    def fetch_learning_objectives
      return if params[:year].blank? && params[:curricular_component_slug].blank?
      @learning_objectives = LearningObjective.all_or_with_year(params[:year])
                                              .all_or_with_curricular_component(params[:curricular_component_slug])
    end
  end
end
