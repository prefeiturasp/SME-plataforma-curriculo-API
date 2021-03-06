module Api
  class FiltersController < ApiController
    before_action :fetch_axes, only: %i[index]
    before_action :fetch_learning_objectives, only: %i[index]
    before_action :fetch_stages, only: %i[index]
    before_action :fetch_years, only: %i[index]


    def index
      @segments = Segment.all
      @regional_education_boards = RegionalEducationBoard.all
      @curricular_components = CurricularComponent.where.not(slug: "trilhas-de-aprendizagens")
      @sustainable_development_goals = SustainableDevelopmentGoal.all
      @knowledge_matrices = KnowledgeMatrix.all

      @curricular_components.present? ? render(:index) : render(json: {}, status: :no_content)
    end

    private

    def set_activity_sequence_params
      params.permit(
        :curricular_component_slugs,
        :segment_id,
        :stage_id,
        :year_ids,
      )
    end

    def fetch_years
      @years = Year.all_or_with_year(params[:stage_id])
    end

    def fetch_stages
      @stages = Stage.all_or_with_segment(params[:segment_id])
    end

    def fetch_axes
      @axes = Axis.all_or_with_curricular_component(params[:curricular_component_slugs])
    end

    def fetch_learning_objectives
      return [] unless params[:year_ids].present? || params[:curricular_component_slugs].present?
      @learning_objectives = LearningObjective.all_or_with_year(params[:year_ids])
                                              .all_or_with_curricular_component(params[:curricular_component_slugs])
    end
  end
end
