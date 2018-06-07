module Api
  class FiltersController < ApiController
    before_action :set_activity_sequence_params, only: %i[activity_sequence_index_filter]
    before_action :set_curricular_component, only: %i[activity_sequence_index_filter]
    before_action :fetch_axes_and_learning_objectives_by_year, only: %i[activity_sequence_index_filter]

    def activity_sequence_index
      @years = LearningObjective.years

      @curricular_components = CurricularComponent.all
      @sustainable_development_goals = SustainableDevelopmentGoal.select(:id, :sequence, :name)
      @learning_objectives = LearningObjective.all
      @knowledge_matrices = KnowledgeMatrix.all
      @axes = Axis.all
      @activity_types = ActivityType.all

      @curricular_components.present? ? render(:activity_sequence_index) : render(json: {}, status: :no_content)
    end

    def activity_sequence_index_filter
      if params[:curricular_component_friendly_id]
        render status: :no_content unless @curricular_component

        @axes = @curricular_component.axes.where(year: params[:year])
        @learning_objectives = @curricular_component.learning_objectives.where(year: params[:year])
      end

      render :activity_sequence_index_filter
    end

    private

    def set_activity_sequence_params
      params.permit(
        :year,
        :curricular_component_friendly_id
      )
    end

    def set_curricular_component
      return unless params[:curricular_component_friendly_id]
      @curricular_component = CurricularComponent.friendly.find(params[:curricular_component_friendly_id])
    end

    def fetch_axes_and_learning_objectives_by_year
      return if params[:curricular_component_friendly_id]
      @axes = Axis.where(year: params[:year].to_i)
      @learning_objectives = LearningObjective.where(year: params[:year].to_i)
    end
  end
end
